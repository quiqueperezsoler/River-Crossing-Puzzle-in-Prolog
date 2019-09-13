% Author: Enrique Perez Soler
% Logic Programming - KTH Kista
%
%%%%%%%%%%%%%%	 The Problem of the Fox, the Sheep and the Beans 	%%%%%%%%%%%%%%

%%% Initial status
% - amount of purchases: foxes, sheeps, bags of beans and capacity of boat
% - situation in each shore: all in shore 1 nothing in shore 2
init(status(shore(1, Foxes, Sheeps, Beans), shore(0, 0, 0, 0), Capacity)):-
	write("\t* Number of Foxes: "), read(Foxes),
	write("\t* Number of Sheeps: "), read(Sheeps),
	write("\t* Number of Bean bags: "), read(Beans),
	write("\t* Boat capacity: "), read(Capacity).

%%% End status
% - amount of purchases: foxes, sheeps, bag of beans and capacity of boat
% - situation in each shore: nothing in shore1 all in shore 2
end(status(shore(0, 0, 0, 0), shore(1, _, _, _), _)).


%%%%%%%%%%%%%%%%%  Conditions for the problem to be safe  %%%%%%%%%%%%%%%%%%%%
% Si = initial Shore
% Sf = final Shore
% There's no problem... if in both shores the purchases are safe 
no_problem(Status):-
	Status = status(Si, Sf, _),
	safe(Si),
	safe(Sf).

%%%%%%%%%%%%%%%%%%%%%%%%   Safe Statuses   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Status in which there are no Sheeps when in the shore there're Foxes and Beans
 safe(S):-
	S = shore(_, Foxes, Sheeps, Beans),
	Sheeps = 0, Foxes > 0, Beans > 0.
	
% Status in which there are no Sheeps but in the shore there are Foxes
safe(S):-
	S = shore(_, Foxes, Sheeps, _),
	Sheeps = 0, Foxes > 0.

% Status in which there are no Sheeps but in the shore there are Beans
safe(S):-
	S = shore(_, _, Sheeps, Beans),
	Sheeps = 0, Beans > 0.

% Status in which there are no Foxes neither Beans but in the shore there're Sheeps
safe(S):-
	S = shore(_, Foxes, Sheeps, Beans),
	Sheeps > 0, Foxes = 0, Beans = 0.

% Status in which the Sheeps and the farmer are in the same shore
safe(S):-
	S = shore(Farmer, _, Sheeps, _),
	Sheeps > 0, Farmer = 1.

% Status in which there are no more purchases left on the initial shore
safe(S):-
	S = shore(_, Foxes, Sheeps, Beans),
	Sheeps = 0, Foxes = 0, Beans = 0.

%%%%%%%%%%%%%%%%%%%%  Available Movements  %%%%%%%%%%%%%%%%%%%%%
% Farmer (F) travels from one shore to the other with the sheep
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),
	
	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Foxf1 is Foxi1, Foxf2 is Foxi2,
	Sheepf1 is Sheepi1, Sheepf2 is Sheepi2,
	Beansf1 is Beansi1, Beansf2 is Beansi2,
	
	% here we check  that the status are left safe to continue travelling
	no_problem(StatusF).


% farmer travels with the Sheeps from StatusI to StatusF when Sheeps = Capacity - 1
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),
	
	Sheepi1 =:= (Capacity-1),
	Sheepf1 is Sheepi1 - (Capacity - 1),
	Sheepf2 is Sheepi2 + (Capacity - 1),

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Foxf1 is Foxi1, Foxf2 is Foxi2,
	Beansf1 is Beansi1, Beansf2 is Beansi2,

	no_problem(StatusF).

% farmer travels with the Sheeps from StatusF to StatusI when Sheeps = Capacity - 1
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),
	
	Sheepi2 =:= (Capacity-1),
	Sheepf1 is Sheepi1 + (Capacity - 1),
	Sheepf2 is Sheepi2 - (Capacity - 1),

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Foxf1 is Foxi1, Foxf2 is Foxi2,
	Beansf1 is Beansi1, Beansf2 is Beansi2,

	no_problem(StatusF).

% farmer travels with the Sheeps from StatusI to StatusF when Sheeps < Capacity-1
% and the amount of Beans and Foxes fit in the empty space
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),

	% if the num of Sheeps is lower thant the boat capacity
	Sheepi1 < (Capacity-1), Beansi1 =< (Capacity - 1) - Sheepi1, Foxi1 =< (((Capacity - 1) - Sheepi1) - Beansi1),
	
	% farmer takes all the Sheeps, Foxes and Beans that fit on the boat
	Sheepf1 is 0, Sheepf2 is Sheepi2 + Sheepi1,
	Beansf1 is 0, Beansf2 is Beansi2 + Beansi1,
	Foxf1 is 0, Foxf2 is Foxi2 + Foxi1,

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,

	no_problem(StatusF).


% farmer travelswith the Sheeps from StatusI to StatusF when Sheeps < Capacity-1
% and the amount of Foxes fit in the empty remaining space
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),

	% If the number of Sheeps is lower than the boat capacity
	Sheepi1 < (Capacity-1), Foxi1 =< (Capacity - 1) - Sheepi1,
	
	% Farmer takes all the Sheeps and Foxes
	Sheepf1 is 0, Sheepf2 is Sheepi2 + Sheepi1,
	Foxf1 is 0, Foxf2 is Foxi2 + Foxi1,

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Beansf1 is Beansi1, Beansf2 is Beansi2,

    no_problem(StatusF).


% farmer travels with the Sheeps from StatusI to StatusF when Sheeps < Capacity-1
% and the amount of Beans fit in the empty space
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),

	% If the number of Sheeps is lower than the boat capacity (counting the farmer)
	Sheepi1 < (Capacity-1), Beansi1 =< (Capacity - 1) - Sheepi1,
	
	% Farmer takes all the Sheeps and Foxes
	Sheepf1 is 0, Sheepf2 is Sheepi2 + Sheepi1,
	Beansf1 is 0, Beansf2 is Beansi2 + Beansi1,

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Foxf1 is Foxi1, Foxf2 is Foxi2,

	no_problem(StatusF).


% farmer travels with the Sheeps from StatusI to StatusF when Sheeps < Capacity-1
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),

	% If the number of Sheeps is lower than the boat capacity (counting the farmer)
	Sheepi1 < (Capacity-1),
	
	% Farmer takes all the Sheeps
	Sheepf1 is 0, 
	Sheepf2 is Sheepi2 + Sheepi1,

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Foxf1 is Foxi1, Foxf2 is Foxi2,
	Beansf1 is Beansi1, Beansf2 is Beansi2,

	no_problem(StatusF).	

% farmer travels with the Sheeps from StatusF to StatusI when Sheeps < Capacity-1
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),

	% If number of Sheeps is lower than boat capacity (counting the farmer)
	Sheepi2 < (Capacity-1),
	
	% farmer takes all the Sheeps
	Sheepf2 is 0, 
	Sheepf1 is Sheepi2 + Sheepi1,

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Foxf1 is Foxi1, Foxf2 is Foxi2,
	Beansf1 is Beansi1, Beansf2 is Beansi2,

	no_problem(StatusF).

% farmer travls from StatusI to StatusF when Sheeps < Capacity-1 and Foxes > Capacity-1
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),
	
	% we verify that Sheeps < Capacity-1 and Foxes > Capacity-1
	Sheepi1 < (Capacity - 1), Foxi1 > (Capacity - 1),

	% we move the Sheeps and the Foxes left in the boat
	Sheepf1 is 0, Sheepf2 is Sheepi1 + Sheepi2,
	Foxf1 is Foxi1 - ((Capacity - 1) - Sheepi1), Foxf2 is Foxi2 + ((Capacity - 1) - Sheepi1),

	Beansf1 is Beansi1, Beansf2 is Beansi2,
	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,

	no_problem(StatusF).


% farmer travels from StatusI to StatusF when Sheeps > Capacity-1 and 
% there are no Sheeps nor Foxes in the shore to take from
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),

	% if the number of Sheeps is bigger than the boat capacity
	Sheepi1 >= (Capacity-1), Foxi1 =:= 0, Beansi1 =:= 0,
    
	% and there are no Foxes nor Beans at the shore,
    % farmer takes the Sheeps that fit in the boat
	Sheepf1 is Sheepi1 - (Capacity-1),
	Sheepf2 is Sheepi2 + (Capacity-1),

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Foxf1 is Foxi1, Foxf2 is Foxi2,
	Beansf1 is Beansi1, Beansf2 is Beansi2,

	no_problem(StatusF).

% farmers travels from StatusI to StatusF with another purchase when Sheeps > Capacity-1
% and the sum of the Foxes and the Beans is < Capacity-1
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),

	% if the number of Sheeps is bigger than the boat capacity
	Sheepi1 >= (Capacity-1), (Foxi1 + Beansi1) =< (Capacity-1),
	
	% and the sum of the Foxes and the Beans are smaller than the boat capacity,
	% farmer takes
	Foxf1 is 0, Foxf2 is Foxi2 + Foxi1,
	Beansf1 is 0, Beansf2 is Beansi2 + Beansi1,

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Sheepf1 is Sheepi1, Sheepf2 is Sheepi2,

	no_problem(StatusF).

% farmer travels from StatusF to StatusI with another purchase when Sheeps > Capacity-1
% the sum of the Foxes and the Beans is < Capacity-1
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),

	% si las Sheeps es mayor que la capacidad del bote
	Sheepi2 >= (Capacity-1), (Foxi2 + Beansi2) =< (Capacity-1),
	% y las Foxes + Beans < Capacity-1, el granjero se los lleva
	Foxf2 is 0, Foxf1 is Foxi2 + Foxi1,
	Beansf2 is 0, Beansf1 is Beansi2 + Beansi1,

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Sheepf1 is Sheepi1, Sheepf2 is Sheepi2,	

	no_problem(StatusF).


% farmer travels with the Foxes when Foxes = Capacity-1
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),
	
	Foxi1 =:= (Capacity - 1),
	Foxf1 is Foxi1 - (Capacity - 1),
	Foxf2 is Foxi2 + (Capacity - 1),

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Sheepf1 is Sheepi1, Sheepf2 is Sheepi2,
	Beansf1 is Beansi1, Beansf2 is Beansi2,

	no_problem(StatusF).

% farmer travels with Foxes when Foxes < Capacity-1 and Beans fit in
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),
	
	% if num of Foxes is lesser than the boat capacity and Beans fit in
	Foxi1 < (Capacity - 1), Beansi1 =< (Capacity - 1) - Foxi1,
	
	% farmer takes all Foxes and Beans that fit in
	Foxf1 is 0, Foxf2 is Foxi2 + Foxi1,
	Beansf1 is 0, Beansf2 is Beansi2 + Beansi1,

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Sheepf1 is Sheepi1, Sheepf2 is Sheepi2,	

	no_problem(StatusF).

% farmer travels with Foxes when Foxes < Capacity-1
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),
	
	% if the num of Foxes is lesser than the boat capacity
	Foxi1 < (Capacity - 1),

	% farmer takes all the Foxes
	Foxf1 is 0,
	Foxf2 is Foxi2 + Foxi1,

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Sheepf1 is Sheepi1, Sheepf2 is Sheepi2,
	Beansf1 is Beansi1, Beansf2 is Beansi2,

	no_problem(StatusF).



% farmer travels with the Beans when Beans = Capacity-1
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),

	Beansi1 =:= (Capacity - 1),
	Beansf1 is Beansi1 - (Capacity - 1),
	Beansf2 is Beansi2 + (Capacity - 1),

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Sheepf1 is Sheepi1, Sheepf2 is Sheepi2,
	Foxf1 is Foxi1, Foxf2 is Foxi2,

	no_problem(StatusF).

% farmer travels with the Beans from StatusI to StatusF when Beans < Capacity-1 and Foxes fit
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),

	Beansi1 < (Capacity - 1),  Foxi1 =< (Capacity - 1) - Beansi1,
	Beansf1 is 0, Beansf2 is Beansi2 + Beansi1,
	Foxf1 is 0, Foxf2 is Foxi2 + Foxi1,

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Sheepf1 is Sheepi1, Sheepf2 is Sheepi2,

	no_problem(StatusF).

% farmer travels with the Beans from StatusI to StatusF when Beans < Capacity-1
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),

	Beansi1 < (Capacity - 1), 
	Beansf1 is 0,
	Beansf2 is Beansi2 + Beansi1,

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Sheepf1 is Sheepi1, Sheepf2 is Sheepi2,
	Foxf1 is Foxi1, Foxf2 is Foxi2,

	no_problem(StatusF).

% farmer travels with the Beans from StatusI to StatusF when Beans > Capacity-1
travel(StatusI, StatusF):-
	StatusI = status(Si1, Si2, Capacity),
	Si1 = shore(Farmeri1, Foxi1, Sheepi1, Beansi1),
	Si2 = shore(Farmeri2, Foxi2, Sheepi2, Beansi2),	

	StatusF = status(Sf1, Sf2, Capacity),
	Sf1 = shore(Farmerf1, Foxf1, Sheepf1, Beansf1),
	Sf2 = shore(Farmerf2, Foxf2, Sheepf2, Beansf2),

	Beansi1 > (Capacity - 1), 
	Beansf1 is Beansi1 - (Capacity - 1),
	Beansf2 is Beansi2 + (Capacity - 1),

	Farmerf1 is Farmeri2, Farmerf2 is Farmeri1,
	Sheepf1 is Sheepi1, Sheepf2 is Sheepi2,
	Foxf1 is Foxi1, Foxf2 is Foxi2,

	Succcess = 'Success compiling \n',
	
	no_problem(StatusF).

%%%%%%%%%%%%%%%%%%%%%%%%%  PRINT STATUS TABLE  %%%%%%%%%%%%%%%%%%%%%%%%% 

table([Status]):- % prints the first case scenario
	Status = status(S1, S2, _),
	S1 = shore(Farmer1, Foxes1, Sheeps1, Beans1),
	S2 = shore(Farmer2, Foxes2, Sheeps2, Beans2),	
	write(Farmer1),write('\t'),write(Foxes1),write('\t'),write(Sheeps1),write('\t'),write(Beans1),
	write('     |~ ~ ~|    '),
	write(Farmer2),write('\t'),write(Foxes2),write('\t'),write(Sheeps2),write('\t'),write(Beans2),nl,
	write('  			      | ~ ~ |    '),nl.
table([Status|List]):- % prints the updated status
	table(List),
	Status = status(S1, S2, _),
	S1 = shore(Farmer1, Foxes1, Sheeps1, Beans1),
	S2 = shore(Farmer2, Foxes2, Sheeps2, Beans2),
	write(Farmer1),write('\t'),write(Foxes1),write('\t'),write(Sheeps1),write('\t'),write(Beans1),
	write('     |~ ~ ~|    '),
	write(Farmer2),write('\t'),write(Foxes2),write('\t'),write(Sheeps2),write('\t'),write(Beans2),nl,
	write('  			      | ~ ~ |    '),nl.
	
%%%%%%%%%%%%%%%%%%%%%%%%%  MOVEMENT FUNCTION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% deepSearch(Istatus, Path, Rest) does a deep search where : 
%  Istatus = initial status
%  Path = visited path (inverted)
%  Rest = total path left to solution (inverted)
deepSearch(Istatus, Path, Path) :- end(Istatus). % finishes when the end status is reached
deepSearch(Istatus, Path, Rest) :-  
	travel(Istatus, Istatus1),
	% write(travel(Istatus, Istatus1)),nl,
	not(member(Istatus1, Path)),
	% write(not(member(Istatus1, Path))),nl,
    deepSearch(Istatus1, [Istatus1|Path], Rest).
	%write(deepSearch(Istatus1, [Istatus1|Path], Rest)),nl.
		   
%%%%%%%%%%%%%%%%%%%%%%%%%  RESOLVE FUNCTION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		   
solution:- 
	nl,
	write('******* PROBLEM OF THE RIVER CROSSING *******'),
	nl,nl,
	write('Enter initial parameters:\n'),nl,
	
	init(StatusI),
	StatusI = status(Si, Sf, Capacity),
	StatusF = status(Sf, Si, Capacity),
	end(StatusF),
	Status = StatusI,

	deepSearch(Status, [Status], Rest),nl,
	write('Solution:\n'),nl,
	write('\tShore 1'),write('\t\t\t\t\t'),write('Shore 2'),nl,
	write('Farmer\tFox\tSheep\tBeans'),
	write('          '),
	write('Farmer\tFox\tSheep\t Beans'),nl,
	table(Rest).
	

ALGO:

1. Current utility matrix - randomly choose individual i
2. Make a random connection 
  2a. If adjacency matrix for ith row has 0 entry for any column set it to 1  
  2b. Keep track of the column number in a vector
3. Recalculate utilities save in a vector (cell array ?) of utilities
4. Goto 2. until max number of tries exhausted
5. Choose among all the above options in step 2b. based on utilities obtained (i.e. among those in step 3. ...
 
------------------------------------------------------------------------------------------

Possible to restrict number of actions to N? By choosing from the actions {"stay", "flip action 1", "flip action 2", ..., "flip action N-1"}.

Run simulation in continuous time to avoid simultaneous changes of action. Randomly select one player at a time and evaluate that player's strategy to determine new adjacency matrix. Utility can then be either updated instantaneously at each "step" or leaky-integrated over time. Imitation dynamics can be included so that evolutionary time (slow) and game time (fast) occur together, without predetermined number of rounds.




*** Strategies ***

Altruistic strategy:
	Maximizes the total score for everyone

"Fair" strategy:
	If I have more score than the average, then I try to be altruistic, otherwise I'm selfish.

Greedy strategy:
	Always goes for the immediate Nash equilibrium! (Maximizes own score)

"Democratic" strategy:
	Some sort of maximizing the score of my audience - choice of strategy is based on the audience/followers
	
"Imitate strategy" Players change their strategy by imitating the majority, with a rule that depends on the strategies with which they have interacted (follower or followed) - emphasizes the importance of network effect (social behaviour) and learning as a side-effect

??? Neural networks ???
Taking the audience distribution as input and the output nodes of the network would determine the probability of connecting to someone in the specific audiences.

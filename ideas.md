
ALGO:

1. Current utility matrix - randomly choose individual i
2. Make a random connection

  2a. If adjacency matrix for ith row has 0 entry for any column set it to 1  
  2b. Keep track of the column number in a vector
3. Recalculate utilities save in a vector (cell array ?) of utilities
4. Goto 2. until max number of tries exhausted
5. Choose among all the above options in step 2b. based on utilities obtained i.e. among those in step 3. ...

  5 a. Choose based on the strategies below
 
------------------------------------------------------------------------------------------

Possible to restrict number of actions to N? By choosing from the actions {"stay", "flip action 1", "flip action 2", ..., "flip action N-1"}.

Run simulation in continuous time to avoid simultaneous changes of action. Randomly select one player at a time and evaluate that player's strategy to determine new adjacency matrix. Utility can then be either updated instantaneously at each "step" or leaky-integrated over time. Imitation dynamics can be included so that evolutionary time (slow) and game time (fast) occur together, without predetermined number of rounds.  

With only one action at a time, we can efficiently store the game history by saving an initial state (if necessary) and a list of actions. The adjacency matrix at any point in history can then be reconstructed quickly with the accumarray command. Similar methods should work with the least-path matrix, population strategy, etc., so that only changes are recorded and reconstructed as needed for analysis.




### Strategies

#### Greedy:
Maximizes own score. Always cut non-looping follows first in random order. If $\beta<\mathrm{cost}$, keep shortest loop if $k<\log\mathrm{cost}/\log\beta$. If $\beta =$ cost, keep last remaining loop. If $\beta>\mathrm{cost}$, keep longest loop.

#### Altruistic:
Maximizes total score of all players. *Possible heuristic* Always add connection to node with highest path length that agent is not already audience to. Remove redundant connections according to $\beta\neq\mathrm{cost}$ cases.

#### "Fair":
Greedy if utility is below mean, altruistic if above.

#### Team player:
Maximizes total score of own audience. *Possible heuristic* Always add connection to node with highest path length in own audience. Remove redundant connections.
	
#### Copycat:
Player uses current best strategy. Players change their strategy by imitating the majority, with a rule that depends on the strategies with which they have interacted (follower or followed) - emphasizes the importance of network effect (social behaviour) and learning as a side-effect

#### Partition:
Player uses the path length and connection information to partition the possible actions, and chooses action from a probability distribution on the partition.

#### Neural network:
Like partition player, but uses partition as input to a neural network and probability distribution as output.

#### Partition history:
Player uses current and historical path length and connection information.

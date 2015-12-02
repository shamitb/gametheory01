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
	Some sort of maximizing the score of my audience

??? Neural networks ???
Taking the audience distribution as input and the output nodes of the network would determine the probability of connecting to someone in the specific audiences.

extends Node

## Target of the AI
enum AITarget {
	## Target Random ally/enemy
	RANDOM,
	## Target the weakest ally/enemy
	WEAKEST,
	## No target the weakest or strongest ally/enemy (If they are all equally weak or strong, target one of the weak ones with more priority.)
	MIDDLE,
	## Target the strongest ally/enemy
	STRONGEST,
	## Target the ally/enemy with less priority
	LESS_PRIORITY,
	## No target the ally/enemy with less or more priority
	MIDDLE_PRIORITY,
	## Target the ally/enemy with more priority
	MORE_PRIORITY
}

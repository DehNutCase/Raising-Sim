extends Node

const jobs = {
	'farmwork' : {
		'stats': {
			'experience' : 10,
			'gold' : 10,
			'max_hp' : 1,
			'stress' : 3,
		},
		'required_stats': {
			'max_hp' : 10,
			'strength' : 5,
		},
		'difficulty' : -50,
	},
	'masonry' : {
		'stats': {
			'experience' : 20,
			'gold' : 20,
			'strength' : 1,
			'stress' : 6,
		},
		'required_stats': {
			'max_hp' : 400,
			'strength' : 200,
		},
		'difficulty' : -50,
	},
	'tutoring' : {
		'stats': {
			'experience' : 20,
			'gold' : 20,
			'max_mp' : 1,
			'stress' : 6,
		},
		'required_stats': {
			'max_mp' : 400,
			'magic' : 200,
		},
		'difficulty' : -50,
	},
	"wizard's apprentice" : {
		'stats': {
			'experience' : 40,
			'gold' : 10,
			'resistance' : 1,
			'magic': 1,
			'stress' : 12,
		},
		'required_stats': {
			'max_mp' : 600,
			'resistance': 300,
			'magic' : 300,
		},
		'difficulty' : -50,
	},
	'acolyte' : {
		'stats': {
			'experience' : 10,
			'gold' : 1,
			'max_hp' : 1,
			'max_mp': 1,
			'stress' : 1,
		},
		'required_stats': {
			'max_hp' : 200,
			'max_mp': 200,
		},
		'difficulty' : -50,
	},
}

const classes = {
	'magic': {
		'stats': {
			'experience' : 100,
			'gold' : -100,
			'magic' : 3,
			'max_mp' : 3,
			'resistance' : 3,
			'stress' : 5,
		},
		'required_stats': {
			'magic' : 100,
			'max_mp' : 100,
			'resistance' : 100
		},
		'difficulty' : 0,
	},
	'melee': {
		'stats': {
			'experience' : 100,
			'gold' : -100,
			'max_hp' : 3,
			'strength' : 3,
			'defense' : 2,
			'speed' : 1,
			'stress' : 5,
		},
		'required_stats': {
			'strength' : 100,
			'max_hp' : 100,
			'defense' : 100
		},
		'difficulty' : 0,
	},
	'faith': {
		'stats': {
			'experience' : 100,
			'gold' : -100,
			'max_hp' : 3,
			'max_mp' : 2,
			'defense' : 2,
			'resistance' : 2,
			'skill' : 1,
			'stress' : 5,
		},
		'required_stats': {
			'max_hp' : 100,
			'max_mp' : 100,
			'defense' : 50,
			'resistance' : 50,
		},
		'difficulty' : 0,
	}
}

const rests = {
	'free time': {
	'stats': {
			'experience' : 1,
			'stress' : -10,
		}
	},
	'vacation': {
		'stats': {
			'experience' : 5,
			'gold' : -20,
			'magic' : 1,
			'max_mp' : 1,
			'stress' : -20,
		}
	},
	'crafting': {
		'stats': {
			'experience' : 2,
			'gold' : 10,
			'skill' : 1,
			'stress' : -5,
		}
	}
}

const stats = {
	base_stats = ['max_hp', 'max_mp', 'strength', 'magic', 'skill', 'speed',
		'defense', 'resistance'],
	'max_hp' = {
		'label': 'Max HP',
		'emoji': '❤',
		'min' : 0,
	},
	'max_mp' = {
		'label': 'Max MP',
		'emoji': '💙',
		'min' : 0,
	},
	'strength' = {
		'label': 'Strength',
		'emoji': '💪',
		'min' : 0,
	},
	'magic' = {
		'label': 'Magic',
		'emoji': '🪄',
		'min' : 0,
	},
	'skill' = {
		'label': 'Skill',
		'emoji': '🎯',
		'min' : 0,
	},
	'speed' = {
		'label': 'Speed',
		'emoji': '⚡',
		'min' : 0,
	},
	'defense' = {
		'label': 'Defense',
		'emoji': '🛡',
		'min' : 0,
	},
	'resistance' = {
		'label': 'Resistance',
		'emoji': '🥽',
		'min' : 0,
	},
	'stress' = {
		'label': 'Stress',
		'emoji': '😣',
		'min' : 0,
		'max' : 100,
	},
	'level' = {
		'label': 'Level',
		'min' : 1,
	},
	'experience' = {
		'label': 'Experience',
		'min': 0,
	},
	'gold' = {
		'label': 'Gold',
		'emoji': '🪙',
		'max': 1000000,
	}
}

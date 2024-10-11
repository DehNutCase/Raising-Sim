extends Node

const jobs = {
	'farmwork': {
		'stats': {
			'experience': 10,
			'gold': 10,
			'max_hp': 1,
			'stress': 3,
		},
		'required_stats': {
			'max_hp': 10,
			'strength': 5,
		},
		'difficulty': -50,
		'proficiency': 100,
		'proficiency_gain': 10,
		'skill':{
			'proficiency_required': 50,
			'id': 'apprentice_farmer',
		},
	},
	'masonry': {
		'stats': {
			'experience': 20,
			'gold': 20,
			'strength': 1,
			'stress': 6,
		},
		'required_stats': {
			'max_hp': 100,
			'strength': 100,
		},
		'difficulty': -50,
		'proficiency': 200,
		'proficiency_gain': 20,
		'skill':{
			'proficiency_required': 160,
			'id': 'apprentice_mason',
		},
	},
	'tutoring': {
		'stats': {
			'experience': 20,
			'gold': 50,
			'max_mp': 1,
			'scholarship': 5,
			'stress': 6,
		},
		'required_stats': {
			'max_mp': 0,
			'magic': 0,
			'scholarship': 200,
		},
		'difficulty': -50,
		'proficiency': 200,
		'proficiency_gain': 20,
		'skill':{
			'proficiency_required': 100,
			'id': 'diligent_student',
		},
	},
	"wizard's apprentice": {
		'stats': {
			'experience': 40,
			'gold': 10,
			'resistance': 1,
			'magic': 1,
			'stress': 12,
		},
		'required_stats': {
			'max_mp': 100,
			'resistance': 100,
			'magic': 100,
		},
		'difficulty': -50,
		'proficiency': 200,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 250,
			'id': 'wizarding_license_apprentice',
		},
	},
	'acolyte': {
		'stats': {
			'experience': 10,
			'gold': 1,
			'max_hp': 1,
			'max_mp': 1,
			'stress': 1,
		},
		'required_stats': {
			'max_hp': 100,
			'max_mp': 100,
		},
		'difficulty': -50,
		'proficiency': 100,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 200,
			'id': 'church_helper',
		},
	},
	'hunting': {
		'stats': {
			'experience': 50,
			'gold': 50,
			'max_hp': 5,
			'strength': 3,
			'speed': 5,
			'stress': 10,
		},
		'required_stats': {
			'speed': 200,
			'strength': 100,
			'max_hp': 100,
		},
		'difficulty': 0,
		'proficiency': 200,
		'proficiency_gain': 25,
	},
}

const lessons = {
	'Basic Magic Training': {
		'stats': {
			'experience': 50,
			'gold': -100,
			'magic': 2,
			'max_mp': 2,
			'scholarship': 2,
			'resistance': 1,
			'stress': 5,
		},
		'required_stats': {
			'magic': 10,
			'max_mp': 10,
			'resistance': 10,
			'scholarship': 0,
		},
		'difficulty': 0,
		'proficiency': 100,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'basic_magic_training',
		},
	},
	'Basic Melee Training': {
		'stats': {
			'experience': 50,
			'gold': -50,
			'max_hp': 2,
			'strength': 2,
			'defense': 1,
			'speed': 1,
			'stress': 5,
		},
		'required_stats': {
			'strength': 10,
			'max_hp': 10,
			'defense': 10,
			'scholarship': 0,
		},
		'difficulty': 0,
		'proficiency': 100,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'basic_melee_training',
		},
	},
	'Basic Theology': {
		'stats': {
			'experience': 50,
			'gold': -100,
			'max_hp': 3,
			'max_mp': 2,
			'defense': 1,
			'resistance': 1,
			'skill': 1,
			'stress': 5,
		},
		'required_stats': {
			'max_hp': 10,
			'max_mp': 10,
			'defense': 5,
			'resistance': 5,
			'scholarship': 0,
		},
		'difficulty': 0,
		'skill':{
			'proficiency_required': 100,
			'id': 'basic_theology',
		},
	},
	'general education': {
		'stats': {
			'experience': 100,
			'gold': -100,
			'scholarship': 50,
			'stress': 10,
		},
		'required_stats': {
			'scholarship': 0,
		},
		'difficulty': -50,
		'proficiency': 100,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'diligent_student',
		},
	},
	'combat theory': {
		'stats': {
			'experience': 100,
			'gold': -100,
			'max_hp': 1,
			'max_mp': 1,
			'strength': 1,
			'defense': 1,
			'speed': 1,
			'magic': 1,
			'resistance': 1,
			'stress': 5,
		},
		'required_stats': {
			'max_hp': 100,
			'max_mp': 100,
			'scholarship': 0,
		},
		'difficulty': 0,
		'proficiency': 100,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'basic_combat_training',
		},
	},
}

const rests = {
	'free time': {
	'stats': {
			'experience': 1,
			'stress': -10,
		}
	},
	'vacation': {
		'stats': {
			'experience': 5,
			'gold': -20,
			'magic': 1,
			'max_mp': 1,
			'stress': -20,
		}
	},
	'crafting': {
		'stats': {
			'experience': 2,
			'gold': 10,
			'skill': 1,
			'stress': -5,
		}
	}
}

const stats = {
	base_stats = ["max_hp", "max_mp", "strength", "magic", "skill", "speed",
		"defense", "resistance"],
	'max_hp' = {
		'label': 'Max HP',
		'emoji': '❤',
		'min': 0,
	},
	'max_mp' = {
		'label': 'Max MP',
		'emoji': '💙',
		'min': 0,
	},
	'strength' = {
		'label': 'Strength',
		'emoji': '💪',
		'min': 0,
	},
	'magic' = {
		'label': 'Magic',
		'emoji': '🪄',
		'min': 0,
	},
	'skill' = {
		'label': 'Skill',
		'emoji': '🎯',
		'min': 0,
	},
	'speed' = {
		'label': 'Speed',
		'emoji': '⚡',
		'min': 0,
	},
	'defense' = {
		'label': 'Defense',
		'emoji': '🛡',
		'min': 0,
	},
	'resistance' = {
		'label': 'Resistance',
		'emoji': '🥽',
		'min': 0,
	},
	'stress' = {
		'label': 'Stress',
		'emoji': '😣',
		'min': 0,
		'max': 100,
	},
	'level' = {
		'label': 'Level',
		'min': 1,
	},
	'experience' = {
		'label': 'Experience',
		'min': 0,
	},
	'gold' = {
		'label': 'Gold',
		'emoji': '🪙',
		'max': 1000000,
	},
	'scholarship' = {
		'label': 'Scholarship',
		'emoji': '📖',
		'min': 0,
		'max': 1000,
		'bonus_ratio': 200,
	},
	'bonus_exp' = {
		'label': 'Exp Bonus',
		'emoji': '',
		'min': 0,
	},
	'action_points' = {
		'label': 'Action Points',
		'emoji': '',
		'min': 1,
	}
}

const constants = {
	'days_in_month' = 28,
	'months_in_year' = 4,
	'seasons' = ['Spring', 'Summer', 'Autumn', 'Winter'],
}

const locations = {
	'palace': {
		'outcomes':
			[{
				'stats': {
					'stress': -1,
					'gold': 10,
				},
				'toasts': ["Found a shiny coin."],
				'weight': 2,
			},
			{
				'stats': {
					'experience': 20,
					'gold': 20,
				},
				'weight': 1,
				'timeline': 'res://Timelines/timeline.dtl',
			},]
	},
}

const character_classes = {
	'warrior': {
		'base_stats': {
			'max_hp': 50,
			'strength': 10,
			'defense': 5,
			'speed': 5,
			'resistance': 1,
			'gold': 50,
			'experience': 10,
			'action_points': 2,
		},
		'level_stats': {
			'max_hp': 50,
			'strength': 10,
			'defense': 6,
			'speed': 4,
			'resistance': 2,
			'gold': 20,
			'experience': 25,
		},
		'combat_skills': ["warcry"],
		'label': "Warrior",
	},
	'rogue': {
		'base_stats': {
			'max_hp': 20,
			'strength': 10,
			'defense': 5,
			'speed': 10,
			'resistance': 5,
			'gold': 50,
			'experience': 10,
			'action_points': 2,
		},
		'level_stats': {
			'max_hp': 30,
			'strength': 6,
			'defense': 4,
			'speed': 10,
			'resistance': 8,
			'gold': 50,
			'experience': 25,
		},
		'combat_skills': ["preparation"],
		'label': "Rogue",
	},
	'priest': {
		'base_stats': {
			'max_hp': 25,
			'strength': 3,
			'magic': 5,
			'defense': 5,
			'speed': 5,
			'resistance': 10,
			'gold': 25,
			'experience': 50,
			'action_points': 1,
		},
		'level_stats': {
			'max_hp': 30,
			'strength': 2,
			'magic': 8,
			'defense': 6,
			'speed': 4,
			'resistance': 10,
			'gold': 25,
			'experience': 25,
		},
		'combat_skills': ["heal"],
		'label': "Priest",
	},
	'mage': {
		'base_stats': {
			'max_hp': 10,
			'strength': 1,
			'magic': 10,
			'defense': 5,
			'speed': 5,
			'resistance': 5,
			'gold': 100,
			'experience': 100,
			'action_points': 2,
		},
		'level_stats': {
			'max_hp': 20,
			'strength': 2,
			'magic': 10,
			'defense': 2,
			'speed': 6,
			'resistance': 6,
			'gold': 50,
			'experience': 25,
		},
		'combat_skills': ["fireball", "brilliance"],
		'label': "Mage",
	},
}

const races = {
	'slime': {
		'base_stats': {
			'max_hp': 25,
			'strength': 5,
			'defense': 5,
			'speed': 5,
			'resistance': 5,
			'gold': 100,
			'experience': 10,
			'action_points': 1,
		},
		'level_stats': {
			'experience': 1,
		},
		'label': 'Slime',
	},
	'goblin': {
		'base_stats': {
			'max_hp': 50,
			'strength': 10,
			'defense': 10,
			'speed': 10,
			'resistance': 5,
			'gold': 150,
			'experience': 20,
			'action_points': 1,
		},
		'level_stats': {
			'experience': 2,
			'gold': 5,
		},
		'label': 'Goblin',
	},
}

const tower_levels = [
	{
		'level': 0,
		'enemies': [
			{
				"level": 1,
				"character_class": "warrior",
				"race": "slime",
			},
		],
		'description': "A Level One Slime Warrior. Starts weak, but often buffs itself to dangerous levels.",
	},
	{
		'level': 1,
		'enemies': [
			{
				"level": 1,
				"character_class": "rogue",
				"race": "goblin",
			},
		],
		'description': "A Level One Goblin Rogue.",
	},
	{
		'level': 2,
		'enemies': [
			{
				"level": 1,
				"character_class": "mage",
				"race": "slime",
			},
		],
		'description': "A Level One Slime Mage. Good with Fireballs, occasionally buffs, sometimes smacks you with a stick.",
	},
	{
		'level': 3,
		'enemies': [
			{
				"level": 1,
				"character_class": "warrior",
				"race": "slime",
			},
			{
				"level": 1,
				"character_class": "priest",
				"race": "slime",
			},
		],
		'description': "A Warrior and a Priest. Surprisingly, it might be better to take out the Warrior first.",
	},
]

const combat_skills = {
	'warcry': {
		'stats': {
			'strength': 5,
		},
		'weight': 5,
		'effect_target': 'ally',
		'effect_type': 'buff',
		'effect_range': 'area',
		'message': "Strength increased for the enemy party!",
		'label': "Warcry",
	},
	'basic_attack': {
		'weight': 10,
		'effect_target': 'enemy',
		'effect_type': 'attack',
		'effect_range': 'single',
		'effect_strength': 100,
		'label': "Basic Attack"
	},
	'preparation': {
		'stats': {
			'action_points': 1,
		},
		'weight': 5,
		'effect_target': 'self',
		'effect_type': 'buff',
		'effect_range': 'self',
		'message': "Enemy action points increased!",
		'label': "Preparation",
	},
	'heal': {
		'weight': 10,
		'effect_target': 'ally',
		'effect_type': 'heal',
		'effect_range': 'single',
		'effect_strength': 100,
		'label': "Heal"
	},
	'brilliance': {
		'stats': {
			'magic': 5,
		},
		'weight': 10,
		'effect_target': 'ally',
		'effect_type': 'buff',
		'effect_range': 'area',
		'message': "Magic increased for the enemy party!",
		'label': "Brilliance",
	},
	'fireball': {
		'weight': 15,
		'effect_target': 'enemy',
		'effect_type': 'magic_attack',
		'effect_range': 'single',
		'effect_strength': 200,
		'label': "Fireball"
	},
}

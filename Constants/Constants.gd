extends Node
const jobs = {
	'Farmwork': {
		'stats': {
			'experience': 10,
			'gold': 50,
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
	'Housework': {
		'stats': {
			'experience': 10,
			'max_hp': 1,
			'max_mp': 1,
			'stress': 3,
		},
		'required_stats': {
			'max_hp': 10,
			'max_mp': 10,
		},
		'difficulty': -50,
		'proficiency': 100,
		'proficiency_gain': 10,
		'skill':{
			'proficiency_required': 50,
			'id': 'maid_training',
		},
	},
	'Masonry': {
		'stats': {
			'experience': 20,
			'gold': 75,
			'strength': 1,
			'stress': 6,
		},
		'required_stats': {
			'max_hp': 100,
			'strength': 100,
		},
		'difficulty': -50,
		'proficiency': 200,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 140,
			'id': 'apprentice_mason',
		},
	},
	'Tutoring': {
		'stats': {
			'experience': 25,
			'gold': 100,
			'max_mp': 1,
			'scholarship': 5,
			'stress': 6,
		},
		'required_stats': {
			'max_mp': 0,
			'magic': 0,
			'scholarship': 200,
		},
		'difficulty': 0,
		'proficiency': 200,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'diligent_student',
		},
	},
	"Wizard's Apprentice": {
		'stats': {
			'experience': 40,
			'gold': 100,
			'resistance': 1,
			'magic': 1,
			'stress': 12,
		},
		'required_stats': {
			'max_mp': 100,
			'resistance': 100,
			'magic': 100,
		},
		'difficulty': 0,
		'proficiency': 200,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'wizarding_license_apprentice',
		},
	},
	'Acolyte': {
		'stats': {
			'experience': 10,
			'gold': 25,
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
			'proficiency_required': 150,
			'id': 'church_helper',
		},
	},
	'Hunting': {
		'stats': {
			'experience': 50,
			'gold': 150,
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
		'difficulty': 50,
		'proficiency': 200,
		'proficiency_gain': 25,
	},
	'Cook': {
		'stats': {
			'experience': 50,
			'gold': 150,
			'max_hp': 2,
			'max_mp': 2,
			'magic': 1,
			'speed': 2,
			'stress': 15,
		},
		'required_stats': {
			'speed': 100,
			'max_mp': 100,
			'max_hp': 100,
			'magic': 100,
		},
		'difficulty': 25,
		'proficiency': 200,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'budding_chef',
		},
	},
	'Doodle': {
		'stats': {
			'experience': 25,
			'gold': 10,
			'art': 10,
			'stress': 5,
		},
		'required_stats': {
			'art': 10,
		},
		'difficulty': -50,
		'proficiency': 100,
		'proficiency_gain': 25,
	},
	'Painting': {
		'stats': {
			'experience': 100,
			'gold': 100,
			'art': 25,
			'stress': 10,
		},
		'required_stats': {
			'art': 250,
		},
		'difficulty': 0,
		'proficiency': 200,
		'proficiency_gain': 25,
	},
	'Court Painter': {
		'stats': {
			'experience': 250,
			'gold': 500,
			'art': 50,
			'stress': 25,
		},
		'required_stats': {
			'art': 500,
			'skill': 0,
			'scholarship': 0,
		},
		'difficulty': 50,
		'proficiency': 200,
		'proficiency_gain': 25,
	},
	'Preach': {
		'stats': {
			'experience': 10,
			'gold': 50,
			'max_hp': 1,
			'max_mp': 1,
			'magic': 1,
			'resistance': 1,
			'stress': 5,
		},
		'required_stats': {
			'max_hp': 200,
			'max_mp': 200,
		},
		'difficulty': 0,
		'proficiency': 100,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'local_preacher',
		},
	},
	'Teaching Assistant': {
		'stats': {
			'experience': 25,
			'gold': 150,
			'magic': 1,
			'max_mp': 1,
			'scholarship': 10,
			'stress': 15,
		},
		'required_stats': {
			'max_mp': 100,
			'magic': 100,
			'scholarship': 200,
		},
		'difficulty': 0,
		'proficiency': 200,
		'proficiency_gain': 20,
	},
	'Lecture': {
		'stats': {
			'experience': 50,
			'gold': 250,
			'magic': 1,
			'max_mp': 1,
			'scholarship': 5,
			'art': 1,
			'stress': 20,
		},
		'required_stats': {
			'max_mp': 100,
			'magic': 100,
			'scholarship': 400,
			'art': 100,
		},
		'difficulty': 50,
		'proficiency': 200,
		'proficiency_gain': 20,
	},
	'Architect': {
		'stats': {
			'experience': 50,
			'gold': 250,
			'art': 10,
			'scholarship': 10,
			'magic': 1,
			'max_mp': 1,
			'stress': 15,
		},
		'required_stats': {
			'art': 200,
			'scholarship': 200,
			'magic': 100,
			'max_mp': 100,
		},
		'difficulty': 50,
		'proficiency': 200,
		'proficiency_gain': 20,
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
			'gold': -100,
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
		'proficiency': 100,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'basic_theology',
		},
	},
	'General Education': {
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
	'Combat Theory': {
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
	'Intermediate Magic Training': {
		'stats': {
			'experience': 100,
			'gold': -250,
			'magic': 5,
			'max_mp': 5,
			'scholarship': 2,
			'speed': 2,
			'resistance': 2,
			'stress': 15,
		},
		'required_stats': {
			'magic': 100,
			'max_mp': 100,
			'resistance': 100,
			'scholarship': 0,
		},
		'difficulty': 50,
		'proficiency': 200,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'fireball',
		},
	},
	'Intermediate Melee Training': {
		'stats': {
			'experience': 100,
			'gold': -250,
			'max_hp': 10,
			'strength': 5,
			'defense': 2,
			'speed': 2,
			'stress': 15,
		},
		'required_stats': {
			'strength': 100,
			'max_hp': 100,
			'defense': 100,
			'scholarship': 0,
		},
		'difficulty': 50,
		'proficiency': 200,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'intermediate_combat_training',
		},
	},
	'Theology': {
		'stats': {
			'experience': 100,
			'gold': -250,
			'max_hp': 5,
			'max_mp': 2,
			'defense': 3,
			'resistance': 3,
			'skill': 2,
			'stress': 15,
		},
		'required_stats': {
			'max_hp': 100,
			'max_mp': 100,
			'defense': 50,
			'resistance': 50,
			'scholarship': 0,
		},
		'difficulty': 0,
		'proficiency': 200,
		'proficiency_gain': 25,
	},
	'Vanguard Training': {
		'stats': {
			'experience': 200,
			'gold': -500,
			'max_hp': 25,
			'strength': 5,
			'defense': 10,
			'resistance': 5,
			'speed': 2,
			'skill': 1,
			'stress': 25,
		},
		'required_stats': {
			'strength': 100,
			'max_hp': 100,
			'defense': 100,
			'scholarship': 0,
		},
		'difficulty': 100,
		'proficiency': 300,
		'proficiency_gain': 25,
	},
	'Assassin Training': {
		'stats': {
			'experience': 200,
			'gold': -500,
			'max_hp': 5,
			'strength': 10,
			'defense': 2,
			'resistance': 2,
			'speed': 15,
			'skill': 5,
			'stress': 25,
		},
		'required_stats': {
			'strength': 100,
			'speed': 100,
			'skill': 100,
			'scholarship': 0,
		},
		'difficulty': 100,
		'proficiency': 300,
		'proficiency_gain': 25,
	},
	'Artillerist Training': {
		'stats': {
			'experience': 200,
			'gold': -500,
			'magic': 20,
			'max_mp': 5,
			'stress': 25,
		},
		'required_stats': {
			'magic': 200,
			'max_mp': 100,
			'scholarship': 0,
		},
		'difficulty': 100,
		'proficiency': 300,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'meteor',
		},
	},
	'Magic Officer Training': {
		'stats': {
			'experience': 200,
			'gold': -500,
			'magic': 10,
			'max_mp': 5,
			'max_hp': 5,
			'speed': 5,
			'strength': 2,
			'defense': 2,
			'resistance': 2,
			'skill': 1,
			'stress': 25,
		},
		'required_stats': {
			'magic': 100,
			'max_mp': 100,
			'max_hp': 100,
			'scholarship': 0,
		},
		'difficulty': 100,
		'proficiency': 300,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'honorary_officer',
		},
	},
	'Royal Lecture (Theology)': {
		'stats': {
			'experience': 200,
			'gold': -1000,
			'max_hp': 5,
			'max_mp': 5,
			'magic': 10,
			'defense': 5,
			'resistance': 15,
			'skill': 5,
			'speed': 5,
			'strength': 2,
			'stress': 25,
		},
		'required_stats': {
			'max_hp': 100,
			'max_mp': 100,
			'magic': 100,
			'resistance': 100,
			'scholarship': 0,
		},
		'difficulty': 100,
		'proficiency': 300,
		'proficiency_gain': 25,
	},
	'Royal Lecture (Magecraft)': {
		'stats': {
			'experience': 200,
			'gold': -1000,
			'max_mp': 10,
			'magic': 30,
			'resistance': 5,
			'speed': 10,
			'stress': 25,
		},
		'required_stats': {
			'max_mp': 100,
			'magic': 300,
			'scholarship': 0,
		},
		'difficulty': 100,
		'proficiency': 300,
		'proficiency_gain': 25,
	},
}

const rests = {
	'Free Time': {
	'stats': {
			'experience': 1,
			'stress': -10,
		}
	},
	'Library': {
		'stats': {
			'experience': 2,
			'gold': -10,
			'scholarship': 10,
			'stress': -15,
		}
	},
	'Vacation': {
		'stats': {
			'experience': 5,
			'gold': -100,
			'magic': 1,
			'max_mp': 1,
			'stress': -50,
		}
	},
}

const stats = {
	'base_stats' = ["max_hp", "max_mp", "strength", "magic", "skill", "speed",
		"defense", "resistance", "art",],
	'scholarship_unaffected' = ["gold", "stress",],
	"class_change_unaffected" = ["gold", "action_points", "bonus_exp",],
	'max_hp' = {
		'label': 'Health Points',
		'emoji': '❤',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'max_mp' = {
		'label': 'Mana Points',
		'emoji': '💙',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'strength' = {
		'label': 'Strength',
		'emoji': '💪',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'magic' = {
		'label': 'Magic',
		'emoji': '🪄',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'skill' = {
		'label': 'Skill',
		'emoji': '🎯',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'speed' = {
		'label': 'Speed',
		'emoji': '⚡',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'defense' = {
		'label': 'Defense',
		'emoji': '🛡',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'resistance' = {
		'label': 'Resistance',
		'emoji': '🥽',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'stress' = {
		'label': 'Stress',
		'emoji': '😣',
		'min': 0,
		'max': 100,
		'value': -30,
	},
	'level' = {
		'label': 'Level',
		'min': 1,
		'max': 1000,
		'value': 20,
	},
	'experience' = {
		'label': 'Experience',
		'min': 0,
	},
	'gold' = {
		'label': 'Gold',
		'emoji': '🪙',
		'max': 1000000,
		'value': .01,
	},
	'scholarship' = {
		'label': 'Scholarship',
		'emoji': '📖',
		'min': 0,
		'max': 1000,
		'bonus_ratio': 400.0,
		'value': 1,
	},
	'art' = {
		'label': 'Art',
		'emoji': '🎨',
		'max': 1000,
		'value': 2,
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
		'label': 'Palace',
		'outcomes':
			[{
				'stats': {
					'stress': -1,
					'gold': 10,
				},
				'toasts': ["Found a shiny coin."],
				'weight': 1,
			},
			{
				'stats': {
				},
				'weight': 1,
				'toasts': ["Found Hiyori's Corner, let's visit."],
				'timeline': 'res://Timelines/WalkEvents/HiyoriCorner.dtl',
				'first_toasts': ["Found an interesting door, let's go in."],
				'first_timeline': 'res://Timelines/WalkEvents/HiyoriCornerFirst.dtl',
				'flag': "hiyori_corner"
			},],
	},
	'atelier': {
		"label": "Atelier",
		'location_flag': "atelier",
		'outcomes':
			[{
				'stats': {
					'stress': -3,
					'art': 5,
				},
				'toasts': ["Wandered around look at the sculptures since Hiyori wasn't in."],
				'weight': 1,
			},
			{
				'stats': {
				},
				'weight': 1,
				'toasts': ["Hiyori's here, let's go say hi."],
				'timeline': 'res://Timelines/WalkEvents/HiyoriAtelier.dtl',
				'first_toasts': ["Hiyori's here, let's go say hi."],
				'first_timeline': 'res://Timelines/WalkEvents/HiyoriAtelierFirst.dtl',
				'second_toasts': ["Hiyori's here, let's go say hi."],
				'second_timeline': 'res://Timelines/WalkEvents/HiyoriAtelierSecond.dtl',
				'flag': "hiyori_atelier"
			},],
	},
	'storage_room': {
		"label": "Storage Room",
		'location_flag': "storage_room",
		'outcomes':
			[{
				'stats': {
					'stress': -5,
					'art': 3,
				},
				'toasts': ["Had a bit of fun looking around."],
				'weight': 1,
			},
			{
				'stats': {
				},
				'weight': 1,
				'toasts': ["Hiyori's here, let's go say hi."],
				'timeline': 'res://Timelines/WalkEvents/HiyoriAtelier.dtl',
				'first_toasts': ["Found Gray in the storage room."],
				'first_timeline': 'res://Timelines/WalkEvents/StorageRoomFirst.dtl',
				'flag': "storage_room"
			},],
	},
	'reception_hall': {
		"label": "Reception Hall",
		'location_flag': "reception_hall",
		'outcomes':
			[{
				'stats': {
					'stress': -10,
				},
				'toasts': ["Got a cookie from the maid cleaning the hall. It was delicious"],
				'weight': 1,
			},
			{
				'stats': {
				},
				'weight': 1,
				'toasts': ["Her majesty is here."],
				'timeline': 'res://Timelines/WalkEvents/ReceptionHall.dtl',
				'first_toasts': ["There's an omnious presence."],
				'first_timeline': 'res://Timelines/WalkEvents/ReceptionHallFirst.dtl',
				'flag': "reception_hall"
			},],
	},
	'rice_house': {
		"label": "Rice's House",
		'location_flag': "rice_house",
		'outcomes':
			[{
				'stats': {
					'stress': -5,
					'speed': 1,
					'max_hp': 1,
				},
				'toasts': ["Had a relaxing walk."],
				'weight': 1,
			},
			{
				'stats': {
				},
				'weight': 1,
				'toasts': ["Found Rice's house, let's go visit."],
				'timeline': 'res://Timelines/WalkEvents/RiceHouse.dtl',
				'first_toasts': ["Found a pleasant looking cottage in the woods."],
				'first_timeline': 'res://Timelines/WalkEvents/RiceHouseFirst.dtl',
				'flag': "rice_house"
			},],
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
		'portrait': {
			'dumpling': 'res://Art/It Came From The Swamp/Enemies/f_Yakimarsh.png',
			'skeleton': 'res://Art/It Came From The Swamp/Enemies/f_MinionsB.png',
		},
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
		'portrait': {
			'dumpling': 'res://Art/It Came From The Swamp/Enemies/f_LunaChime.png',
			'teru': 'res://Art/It Came From The Swamp/Enemies/f_Teruko.png',
		},
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
		'portrait': {
			'dumpling': 'res://Art/It Came From The Swamp/Enemies/f_candle.png',
			'teru': 'res://Art/It Came From The Swamp/Enemies/f_Teruo.png',
		},
	},
	'assassin': {
		'base_stats': {
			'max_hp': 100,
			'strength': 50,
			'defense': 25,
			'speed': 50,
			'resistance': 25,
			'gold': 500,
			'experience': 250,
			'action_points': 4,
		},
		'level_stats': {
			'max_hp': 50,
			'strength': 10,
			'defense': 5,
			'speed': 15,
			'resistance': 12,
			'gold': 100,
			'experience': 50,
		},
		'combat_skills': ["preparation", "finishing_blow"],
		'label': "Assassin",
		'portrait': {
			'dumpling': 'res://Art/It Came From The Swamp/Enemies/f_Yakimarsh.png',
			'skeleton': 'res://Art/It Came From The Swamp/Enemies/f_CaoptainB.png',
		},
	},
	'rice': {
		'base_stats': {
			'max_hp': 100,
			'strength': 50,
			'defense': 50,
			'speed': 50,
			'magic': 50,
			'resistance': 50,
			'gold': 500,
			'experience': 250,
			'action_points': 4,
		},
		'level_stats': {
			'experience': 100,
			'gold': 100,
			'max_hp': 30,
			'strength': 25,
			'defense': 25,
			'speed': 40,
			'magic': 50,
			'resistance': 25,
		},
		'combat_skills': ["judgement"],
		'label': "Rice",
		'portrait': {
			'lesser_phantom': 'res://Characters/Rice/Images/Portrait/idle_000.png',
		},
	},
}

const races = {
	'dumpling': {
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
		'label': 'Dumpling',
		'portrait': 'res://Art/It Came From The Swamp/Enemies/f_manju.png',
	},
	'skeleton': {
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
		'label': 'Skeleton',
		'portrait': 'res://Art/It Came From The Swamp/Enemies/f_MinionsA.png',
	},
	'teru': {
		'base_stats': {
			'max_hp': 100,
			'strength': 25,
			'defense': 25,
			'speed': 25,
			'resistance': 10,
			'gold': 250,
			'experience': 50,
			'action_points': 2,
		},
		'level_stats': {
			'max_hp': 2,
			'strength': 1,
			'experience': 10,
			'gold': 10,
		},
		'label': 'Teru',
		'portrait': 'res://Art/It Came From The Swamp/Enemies/f_TeruoB.png',
	},
	'lesser_phantom': {
		'base_stats': {
			'max_hp': 50,
			'strength': 10,
			'defense': 10,
			'speed': 10,
			'resistance': 10,
			'magic': 10,
			'gold': 200,
			'experience': 100,
			'action_points': -3,
		},
		'level_stats': {
			'gold': 50,
			'experience': 25,
			'max_hp': -20,
			'strength': -10,
			'defense': -10,
			'speed': -10,
			'magic': -10,
			'resistance': -10,
		},
		'label': 'Lesser Phantom:',
	},
}

const tower_levels = [
	{
		'level': 0,
		'enemies': [
			{
				"level": 1,
				"character_class": "warrior",
				"race": "dumpling",
			},
		],
		'image': "res://Art/It Came From The Swamp/Enemies/f_manju.png",
		'description': "A Dumpling Warrior. Starts weak, but can buff itself to dangerous levels.\n\nDumplings are a variety of slime. Domesticated Dumplings have a fluffy texture and slightly sweet taste, but wild Dumplings are rubbery and bitter. It's considered extremely rude to nibble on Dumplings without asking permission first.",
	},
	{
		'level': 1,
		'enemies': [
			{
				"level": 2,
				"character_class": "rogue",
				"race": "skeleton",
			},
		],
		'image': "res://Art/It Came From The Swamp/Enemies/f_MinionsB.png",
		'description': "A Skeleton Rogue. Gets faster and faster as the fight goes on.\n\nAnimated Skeletons are a common sight anywhere animals have died. Regardless of where the bones came from, all Skeletons share the same basic shape. Surprisingly fond of alcohol, so remember to bring a mop if you invite one to a party. Not a good source of calcium.",
	},
	{
		'level': 2,
		'enemies': [
			{
				"level": 3,
				"character_class": "mage",
				"race": "dumpling",
			},
		],
		'image': "res://Art/It Came From The Swamp/Enemies/f_candle.png",
		'description': "A Dumpling Mage. Good with Fireballs, occasionally buffs, sometimes smacks you with a stick. Don't ask where the stick came from.",
	},
	{
		'level': 3,
		'enemies': [
			{
				"level": 4,
				"character_class": "warrior",
				"race": "teru",
			},
		],
		'description': "A Teru Warrior. Teru are naturally stronger and faster than Dumplings or Skeletons.\n\nTeru, or 'teru teru bōzu', are a relatively new variety of ghost. Small and friendly, they are commonly thought to be signs of good weather. Likes hanging themselves on string and often surprise people accidentally while doing so. Non-edible, so please stop trying.",
		'image': "res://Art/It Came From The Swamp/Enemies/f_TeruoB.png",
	},
	{
		'level': 4,
		'enemies': [
			{
				"level": 5,
				"character_class": "warrior",
				"race": "dumpling",
			},
			{
				"level": 5,
				"character_class": "priest",
				"race": "dumpling",
			},
		],
		'image': "res://Art/It Came From The Swamp/Enemies/f_LunaChime.png",
		'description': "A Dumpling Warrior and a Dumpling Priest. Surprisingly, it might be better to take out the Warrior first.\n\nA Dumpling's taste changes depending on its class. Unfortunately, wild varieties get less palatable from changing to a rarer class. Domesticated Dumplings, on the other hand, are too expensive to be affordable outside of the most common Warrior class.",
	},
	{
		'level': 5,
		'enemies': [
			{
				"level": 6,
				"character_class": "warrior",
				"race": "skeleton",
			},
			{
				"level": 6,
				"character_class": "mage",
				"race": "teru",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_MinionsA.png',
		'description': "A Skeleton Warrior and a Teru Mage. Although Teru don't have any specific advantages in casting magic, their high speed means they make excellent mages nontheless.",
	},
	{
		'level': 6,
		'enemies': [
			{
				"level": 7,
				"character_class": "warrior",
				"race": "teru",
			},
			{
				"level": 7,
				"character_class": "rogue",
				"race": "skeleton",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_TeruoB.png',
		'description': "A Teru Warrior and a Skeleton Rogue. Warriors make excellent party leaders and Rogues become quite dangerous if their strength increases.",
	},
	{
		'level': 7,
		'enemies': [
			{
				"level": 8,
				"character_class": "mage",
				"race": "teru",
			},
			{
				"level": 8,
				"character_class": "priest",
				"race": "teru",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_Teruo.png',
		'description': "A Teru Mage and a Teru priest. Combined with a mage, a priest's healing becomes stronger and stronger as time goes on. Watch out for Fireballs.\n\nIt's a common belief that seeing a Teru holding an umbrella is a sign of rain. In fact, however, all Teru have umbrellas, but only Teru Mages carry them even when the sun is shining. Although they'll happily share if asked, it's hard to see how such a tiny umbrella can be helpful when you're being rained on.",
	},
	{
		'level': 8,
		'enemies': [
			{
				"level": 9,
				"character_class": "mage",
				"race": "teru",
			},
			{
				"level": 9,
				"character_class": "mage",
				"race": "dumpling",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_candle.png',
		'description': "A Teru Mage and a Dumpling Mage. Fireballs hurt, and buffed Fireballs hurt even more.",
	},
	{
		'level': 9,
		'enemies': [
			{
				"level": 10,
				"character_class": "warrior",
				"race": "dumpling",
			},
			{
				"level": 10,
				"character_class": "rogue",
				"race": "dumpling",
			},
			{
				"level": 10,
				"character_class": "mage",
				"race": "dumpling",
			},
			{
				"level": 10,
				"character_class": "priest",
				"race": "dumpling",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_Yakimarsh.png',
		'description': "A Dumpling adventuring party! Even Dumplings get to go on adventures. Although the road ahead is long, they've taken their first steps to becoming Heroes.\n\nAccording to a certain King of Demons, Dumpling Heroes are surprisingly delicious. Apparently the Dumpling Hero regressed back to being a Dumpling Swordmaster afterwards, although it's not certain if it's because it lost or because she took a bite.",
	},
	{
		'level': 10,
		'enemies': [
			{
				"level": 11,
				"character_class": "warrior",
				"race": "teru",
			},
			{
				"level": 11,
				"character_class": "warrior",
				"race": "teru",
			},
			{
				"level": 11,
				"character_class": "assassin",
				"race": "skeleton",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_CaoptainB.png',
		#TODO, continue work here
		'description': "Two Teru Warriors and a Skeleton Assassin. Assassin is an advanced class with extreme speed and damage. Due to being an advanced class, even their 'weak' stats are quite high. (It's not a good idea to fight advanced classes as a non-combat class, but part of Mao's contract is to stay in her original class)",
	},
	{
		'level': 14,
		'enemies': [
			{
				"level": 15,
				"character_class": "rice",
				"race": "lesser_phantom",
			},
		],
		'description': "Phantoms are monsters that mimic the appearance and ability of others. This one is a lesser phantom, so it's far weaker and slower than the original. Unfortunately this one is a phantom of Rice, whose favorite skill happens to deal extreme damage while ignoring defenses. Consider asking Rice for advice if you lose.",
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
		'message_player': "Strength increased!",
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
		'message_player': "Action points increased!",
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
	'light_barrier': {
		'weight': 10,
		'effect_target': 'ally',
		'effect_type': 'heal',
		'effect_range': 'single',
		'effect_strength': 250,
		'label': "Light Barrier",
		#'animation': "res://Characters/Rice/Videos/mtn_03.ogv", #TODO, replace with enemy animation
		'animation_player': "res://Characters/Mao/Videos/special_01.ogv",
		'animation_length_player': 3.8,
		'animation_size_player': Vector2(600, 750),
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
		'message_player': "Magic increased!",
		'label': "Brilliance",
	},
	'paintball': {
		'weight': 10,
		'effect_target': 'enemy',
		'effect_type': 'magic_attack',
		'effect_range': 'single',
		'effect_strength': 50,
		'label': "Paintball"
	},
	'fireball': {
		'weight': 15,
		'effect_target': 'enemy',
		'effect_type': 'magic_attack',
		'effect_range': 'single',
		'effect_strength': 200,
		'label': "Fireball"
	},
	'meteor': {
		'weight': 10,
		'effect_target': 'enemy',
		'effect_type': 'magic_attack',
		'effect_range': 'area',
		'effect_strength': 150,
		'label': "Meteor",
		'animation_player': "res://Characters/Mao/Videos/mtn_04.ogv",
		'animation_length_player': 2.0,
		'animation_size_player': Vector2(600, 750),
	},
	'finishing_blow': {
		'weight': 5,
		'effect_target': 'enemy',
		'effect_type': 'physical_attack',
		'effect_range': 'single',
		'effect_strength': 300,
		'label': "Finishing Blow"
	},
	'judgement': {
		'weight': 100,
		'effect_target': 'enemy',
		'effect_type': 'special_fixed',
		'effect_range': 'single',
		'effect_strength': 1000,
		'label': "Judgement",
		'animation': "res://Characters/Rice/Videos/mtn_03.ogv",
		'animation_length': 4,
		'animation_size': Vector2(900, 750),
	},
	'blessing': {
		'stats': {
			'magic': 100,
			'strength': 100,
			'defense': 100,
			'resistance': 100,
			'speed': 100,
			'skill': 100,
		},
		'weight': 10,
		'effect_target': 'ally',
		'effect_type': 'buff',
		'effect_range': 'area',
		'message': "Stats drastically increased for enemy party!",
		'message_player': "Stats drastically increased!",
		#'animation': "res://Characters/Rice/Videos/mtn_03.ogv", #TODO, replace with enemy animation
		'animation_player': "res://Characters/Mao/Videos/special_03.ogv",
		'animation_length_player': 7.7,
		'animation_size_player': Vector2(600, 750),
		'label': "Blessing",
	},
}

const player_classes = {
	"ink_mage": {
		"description": "A magician with an affinity for ink. A rare non-combat variant of the magician class. \nAs a non-combat class, stat gains from leveling up are low, combat skills are difficult to acquire, and experience can be obtained for non-combat actions.",
		"id": "ink_mage",
		"label": "Ink Mage",
		"tier": 0,
		"type": "",
	},
	"ink_mage_journeyman": {
		"description": "A promoted ink mage. As a natural promotion to the basic ink mage class, requirements are low and stats are similar across the board. \n\nThe ink mage series has access to most types of magic, but won't learn spells from level ups.",
		"id": "ink_mage_journeyman",
		"label": "Ink Mage (Journeyman)",
		"tier": 1,
		"type": "Non-combat",
		"required_stats": {
			"level": 1,
			"max_hp": 100,
			"max_mp": 50,
			"strength": 20,
			"magic": 50,
			"speed": 25,
			"defense": 20,
			"resistance": 30,
			"scholarship": 100,
			"art": 50,
		},
	},
	"magic_officer_trainee": {
		"description": "A newly developed 'hybrid' version of the Magic Officer (Trainee) class. The original Magic Officer class is a combat class with high magic and speed, well rounded access to spells and combat skills, and excellent stat growths and caps.\n\nThe hybrid version is closer to a non-combat class than a combat class: stat gains from leveling up are low, stat caps are average, and experience can be obtained for non-combat actions. Skills can be acquired from leveling up.",
		"id": "magic_officer_trainee",
		"label": "Magic Officer (Trainee)",
		"tier": 1,
		"type": "Hybrid",
		"required_stats": {
			"level": 25,
			"max_hp": 400,
			"max_mp": 200,
			"strength": 200,
			"magic": 300,
			"speed": 300,
			"defense": 200,
			"resistance": 200,
			"skill": 200,
			"scholarship": 200,
		},
		"required_skills": ["honorary_officer"],
	},
}

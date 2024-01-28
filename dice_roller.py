import random

#------
# Dice type block
#------


dice_d4 = list(range(1, 4))
dice_d6 = list(range(1, 6))
dice_d8 = list(range(1, 8))
dice_d10 = list(range(1, 10))
dice_d12 = list(range(1, 12))
dice_d20 = list(range(1, 20))
dice_d100 = list(range(1, 100))

#------
# Simple dice roller on D6 dice as example
#------

roll_dice_question = input("Do you want to roll a dice? ")

if roll_dice_question.lower() == "yes":
    random.shuffle(dice_d6)
    result_of_roll = random.choice(dice_d6)
    print(result_of_roll)


#------
# Extended dice roller with seven possible types of dices
#------


while True:

    roll_dice_question = input("Do you want to roll a dice? ")
    if roll_dice_question.lower() == "yes":
        dice_type_question = input("Which dice would you like to roll: D4, D6, D8, D10, D12, D20 or D100? ")
        if dice_type_question.lower() == "d4":
            random.shuffle(dice_d4)
            result_of_roll = random.choice(dice_d4)
            print(result_of_roll)
        elif dice_type_question.lower() == "d6":
            random.shuffle(dice_d6)
            result_of_roll = random.choice(dice_d6)
            print(result_of_roll)
        elif dice_type_question.lower() == "d8":
            random.shuffle(dice_d8)
            result_of_roll = random.choice(dice_d8)
            print(result_of_roll)
        elif dice_type_question.lower() == "d10":
            random.shuffle(dice_d10)
            result_of_roll = random.choice(dice_d10)
            print(result_of_roll)
        elif dice_type_question.lower() == "d12":
            random.shuffle(dice_d12)
            result_of_roll = random.choice(dice_d12)
            print(result_of_roll)
        elif dice_type_question.lower() == "d20":
            random.shuffle(dice_d20)
            result_of_roll = random.choice(dice_d20)
            print(result_of_roll)
        elif dice_type_question.lower() == "d100":
            random.shuffle(dice_d100)
            result_of_roll = random.choice(dice_d100)
            print(result_of_roll)
        else:
            print("Your input answer is invalid to proceed. Type 'Yes' or 'No' to roll.")



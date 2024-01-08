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
# Simple dice roller
#------

roll_dice_question = input("Do you want to roll a dice? ")

if roll_dice_question.lower() == "yes":
    random.shuffle(dice_d6)
    result_of_roll = random.choice(dice_d6)
    print(result_of_roll)



#------
# Enchanced dice roller
#------
"""    
while True:
    roll_dice_question = input("Do you want to roll a dice? (Type 'Yes' to roll, 'No' to stop): ")    

    if roll_dice_question.lower() == "yes":
        random.shuffle(dice_d6)
        result_of_roll = random.choice(dice_d6)
        print(result_of_roll)
    elif roll_dice_question.lower() == "no":
        print("Well, your loss!")
        break
    else:
        print("Your input answer is invalid to proceed. Type 'Yes' or 'No' to roll.")
"""
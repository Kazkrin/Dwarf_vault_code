"""
def ApproximateValueCalculator(value):
    lowestPossible = value - 0.1 * value
    highestPossilbe = value + 0.1 * value
    return random.randint(lowestPossible, highestPossilbe)
"""

import random
from enum import Enum

def findApproximateValue(value):
    lowestPossible = value - 0.1 * value
    highestPossible = value + 0.1 * value
    return random.randint(lowestPossible, highestPossible)



number_of_chambers = 5

Event = Enum('Event', ['Crate','Nothing'])
eventsDictionary = {Event.Crate: 0.6,Event.Nothing: 0.4}
eventList = list(eventsDictionary.keys())
propabilityOfEvents = list(eventsDictionary.values())


rarityEvent = Enum('Rarity',['Common','Uncommon','Rare','Legendary'])
crateRarity = {rarityEvent.Common: 0.75, rarityEvent.Uncommon: 0.2, rarityEvent.Rare: 0.04 ,rarityEvent.Legendary: 0.01}
rarityEvent = list(crateRarity.keys())
propabilityOfRarityEvent = list(crateRarity.values())


goldEvent = Enum('Gold',['Common','Uncommon','Rare','Legendary'])
goldAmountInCrate = {goldEvent.Common: 100, goldEvent.Uncommon: 500, goldEvent.Rare: 1000 ,goldEvent.Legendary: 2000}
goldEvent = list(goldAmountInCrate.keys())
goldAmount = list(goldAmountInCrate.values())




while number_of_chambers > 0:
    action_choose = input("Are you willing to step forward, human? ")
    if (action_choose == "Yes"):
        print("Very well. Here is what you encounter..")
        events_choice = random.choices(eventList,propabilityOfEvents)[0]
        if (events_choice == Event.Crate):
            print("You have found a crate!")
            rarity_choice = random.choices(rarityEvent,propabilityOfRarityEvent)[0]
            print("Rarity of founded crate is", rarity_choice.name,".You have found ",goldAmount[rarity_choice.value],"gold!")
        elif (events_choice == Event.Nothing):
            print("You enter an empty chamber, human. Take one more step!")
    else:
        print("You can only step forward, mortal!")
        continue
    
    number_of_chambers = number_of_chambers -1
    while (number_of_chambers == 0):
        print("This is the last chamber.You journey ends here, prospector of treasures!" )
        break


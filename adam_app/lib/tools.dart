import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
part 'tools.g.dart';

class DBs {
  void openBoxes(bool isFirstTime) async {
    /// Opens all of the relevant boxes for this app. If [isFirstTime],
    /// initializes the default box values.
    await Hive.openBox('Metroid');
    await Hive.openBox('MetroidII');
    await Hive.openBox('SuperMetroid');
    await Hive.openBox('Fusion');
    await Hive.openBox('ZeroMission');
    await Hive.openBox('OtherM');
    await Hive.openBox('SamusReturns');
    await Hive.openBox('Dread');
    await Hive.openBox('Prime');
    await Hive.openBox('Prime2');
    await Hive.openBox('Prime3');

    //Hive.deleteFromDisk();
    //
    if (isFirstTime) {
      initBoxes();
    }
  }

  void initBoxes() {
    //to be used upon opening the app to ensure that everything is open
    //initialization list variable format is lTG where l = location, T = item type, G = game ID shorthand
    if (Hive.box('Metroid').isEmpty) {
      List<String> lMM1 = [
        "From the long gold shaft in Brinstar, go all the way down, then go right at the bottom until you come to it.",
        "To the right of the Varia Suit, at the top right of Brinstar.",
        "Behind the first red door below the elevator to Kraid's Lair.",
        'Behind the first blue door below the elevator to Kraid\'s Lair. There is a secret passageway to bomb jump into in this room.',
        'To the right of the long drop shaft in Kraid\'s Lair. Requires 5 Missiles.',
        'On the return from Kraid to the elevator, in the shaft of breakable blocks, take the lower of the 2 blue doors.',
        'Go straight left from the elevator to Norfair.',
        'Continuing from Missile 7, head left through the secret passage, then continue.',
        'Above the alternate Ice Beam at the top of Norfair, through a secret pipe below the item statue, and above the shaft to the left.',
        'Straight right of Missile 9.',
        'From Missiles 9/10, go right, drop down through the right side of the floor, then go to the left.',
        'Straight left of Missile 11.',
        'Straight left of Missile 12.',
        'Drop to the "bottom" of the large purple shaft on the right of Norfair, and go all the way left.',
        'Straight to the left of Missile 14.',
        'From the pipe below the High Jump Boots, wind left, down and drop through the fake lava, then right, then down through the secret passage in the one-screen room.',
        'Straight to the right of Missile 16.',
        'Proceed to the end of the winding corridors past the Wave Beam and Missiles 16/17, through the hidden tunnel at the dead end.',
        'To the left of the entrance to Ridley\'s Lair, go through the top right of the second identical white room.',
        'To the right of the pit below Energy Tank 7. Beware of the jump at the end, try bomb jumping for an easier time.',
        'After Ridley, head all the way to the right, then go down and to the left. Alternatively, go left from Energy Tank 7\'s pit.'
      ];
      List<String> lEM1 = [
        'From the long gold shaft in Brinstar, go straight to the right in the center.',
        'To the right of Missile 2 and Varia Suit. Go through the secret passage at the "dead end" by shooting up and using bombs.',
        'Near the start of the game in the left side of the rock wall near the blue shaft. Requires the Ice Beam or High Jump Boots to reach.',
        'Behind the second red door below the elevator to Kraid\'s Lair. Shoot through the fake wall and bomb jump in.',
        'Located on the lower right wall of Kraid\'s boss room. Requires High Jump Boots.',
        'From the pipe below the High Jump Boots, wind left, down, right, down, and left again.',
        'Proceed straight to the left of the entrance to Ridley\'s Lair. Make sure to jump in the room, or you\'ll fall into a pit.',
        'After Ridley, go left.'
      ];
      List<String> lOTGM1 = [
        'Immediately to the left at the start of the game.',
        "Behind the central door in the easternmost edge of Brinstar. Requires 5 Missiles.",
        "Behind the second highest door in the blue shaft in Brinstar. Requires 5 Missiles.",
        "Below the eastern lava pit room in the central tunnel in Brinstar (leading to Energy Tank 1). 5 Missiles and High Jump Boots, damage boosting, or Bombs required. Alternatively, collect at the top right of Norfair.",
        "Located at the top of Brinstar's eastern half, use either High Jump Boots or the Ice Beam to climb up in the one-screen corridor, then head left. Requires 5 Missiles.",
        "Below the false floor at the bottom of the shaft on the right of Norfair (near missiles 14/15), go down and through the first door on the left.",
        "From the pipe below the High Jump Boots, go left to the one-screen room, and shoot your way up on the right side. Climb up and go left.",
        "From the corridor above Missiles 16/17, go right and drop through the lava in the room with the dragon, then go left.",
      ];
      //add locations descriptors and possibly put one-time gear in addition to collectibles?
      for (int i = 1; i <= 21; i++) {
        Hive.box('Metroid').put(
            "Missiles $i",
            Item(
                itemType: "Missiles $i",
                itemId: i,
                location: lMM1[i - 1],
                checked: false));
        if (i <= 8) {
          Hive.box('Metroid').put(
              "Energy Tank $i",
              Item(
                  itemType: "Energy Tank $i",
                  itemId: i,
                  location: lEM1[i - 1],
                  checked: false));
        }
      }
      Hive.box('Metroid').put(
          "Morph Ball",
          Item(
              itemType: "Morph Ball",
              itemId: 1,
              location: lOTGM1[0],
              checked: false));
      Hive.box('Metroid').put(
          "Bombs",
          Item(
              itemType: "Bombs",
              itemId: 1,
              location: lOTGM1[1],
              checked: false));
      Hive.box('Metroid').put(
          "Varia Suit",
          Item(
              itemType: "Varia Suit",
              itemId: 1,
              location: lOTGM1[4],
              checked: false));
      Hive.box('Metroid').put(
          "High Jump Boots",
          Item(
              itemType: "High Jump Boots",
              itemId: 1,
              location: lOTGM1[5],
              checked: false));
      Hive.box('Metroid').put(
          "Long Beam",
          Item(
              itemType: "Long Beam",
              itemId: 1,
              location: lOTGM1[2],
              checked: false));
      Hive.box('Metroid').put(
          "Ice Beam",
          Item(
              itemType: "Ice Beam",
              itemId: 1,
              location: lOTGM1[3],
              checked: false));
      Hive.box('Metroid').put(
          "Wave Beam",
          Item(
              itemType: "Wave Beam",
              itemId: 1,
              location: lOTGM1[7],
              checked: false));
      Hive.box('Metroid').put(
          "Screw Attack",
          Item(
              itemType: "Screw Attack",
              itemId: 1,
              location: lOTGM1[6],
              checked: false));
    }
    if (Hive.box('MetroidII').isEmpty) {
      List<String> lMM2 = [
        'In the same room as the Bombs.',
        "To the right of Energy Tank 1, go down and right.",
        "In the same room as Missile pod 2.",
        'In the same room as Missile pod 2.',
        'Located above Energy Tank 1, use the Spider Ball to climb around the top and enter from the left using Bombs.',
        'In the same room as Missile pod 5.',
        'Left past the 2 save points in Area 2, drop down into the water, then head right. Located at the top right corner of the next shaft.',
        'After defeating the first Alpha Metroid of Area 2, go up and roll through the hidden passage, and blow your way to the left.',
        'During the Spider Ball section at the top of the shaft on the left side of Area 2, use Bombs at the top left corner of the wall.',
        'In the same room as Energy Tank 2.',
        'At the bottom left of the shaft right of the Wave Beam in Area 2, go left and shoot the blocks in the way.',
        'In the same room as Missile pod 11.',
        'After the Spring Ball, drop down and hug the left wall until you reach an opening with the Morph Ball.',
        'Climb on top of the second part of the ruins in Area 3, and drop into the hole on top. Shoot the sand to reveal it.',
        'Below Missile pod 14, go right in the shaft and use the Spider Ball above the Gamma Metroid and Bombs to blow up the roof.',
        'Head right from the Plasma Beam, or right from the hole in the sand below Missile pod 15.',
        'Drop beneath Energy Tank 3 and blow up the holes to find a second path leading over to this Missile Pod.',
        'After defeating the Gamma Metroid on the way into area 6, drop below the Metroid shell and into the water, then head left.',
        'At the top of the ruins in area 6, drop into the dark and head down and right. Use bombs to find your way.',
        'Just past Energy Tank 6.',
        'Located along the right wall of Area 6, above the Zeta and below the Gamma.'
      ];
      List<String> lEM2 = [
        'To the right of the Bombs, climb the shaft and head right, then defeat the turret and climb over it.',
        "Blow up a hole below the High Jump Boots statue and head down and left. Shoot the floor to the right of the item.",
        "On the right side of the second part of the Area 3 ruins, just below some spikes and just above the missile pod, blow up the wall and roll into the hole.",
        'Head further right past Missile pod 16. At the dead end, jump straight up. Kill the Alpha Metroid, and head left.',
        'Located at the very top of the ruins in area 6. Drop in to the dark, and try to head up and right until you see an exit. Use bombs to path if you get lost.',
        'At the top right of Area 6, use the Spider Ball to climb onto the ceiling. Blow up the wall in the top right corner, and head in.',
      ];
      List<String> lOTGM2 = [
        "In area 1, to the right of the save point, head down, then go left.",
        "In the far right of area 1, after Energy Tank 1, head up and right, then continue right and drop down.",
        "To the right of the Wave Beam, go to the end of the hall, and on the right side of the shaft shoot the blocks and head into the wall. Drop down and go left.",
        "Use the Spider Ball above the boulder at the top of the ruins in Area 2, and drop into the first shaft you see. Defeat the monster.",
        "After Missile pod 7, go down and right, then head up. Use the Spider Ball to climb, then go past the statue in the first room you come to.",
        "Climb over the first part of the ruins in Area 3, and drop into the sand. Go left and climb up.",
        "After defeating the Zeta located inside the right wall of the ruins in Area 6, climb up and go right. Blow up the boulder.",
        "Located below Energy Tank 1, drop down and go left and open the missile door. Also available in area 6.",
        "After defeating Metroid #27, go down on the left side of that room and blow open the floor. Drop through and go left through a hidden passageway. Also available in area 6.",
        "Below Missile pod 14 and the save point nearby, drop all the way down and go left. Also available in area 6.",
        "Beneath the Gamma Metroid room containing Missile pod 15, shoot out the sand and head left. Also available in area 6."
      ];
      for (int i = 1; i <= 21; i++) {
        Hive.box('MetroidII').put(
            "Missiles $i",
            Item(
                itemType: "Missiles $i",
                itemId: i,
                location: lMM2[i - 1],
                checked: false));
        if (i <= 6) {
          Hive.box('MetroidII').put(
              "Energy Tank $i",
              Item(
                  itemType: "Energy Tank $i",
                  itemId: i,
                  location: lEM2[i - 1],
                  checked: false));
        }
      }
      Hive.box('MetroidII').put(
          "Bombs",
          Item(
              itemType: 'Bombs',
              itemId: 1,
              location: lOTGM2[0],
              checked: false));
      Hive.box('MetroidII').put(
          "Spider Ball",
          Item(
              itemType: 'Spider Ball',
              itemId: 1,
              location: lOTGM2[1],
              checked: false));
      Hive.box('MetroidII').put(
          "High Jump Boots",
          Item(
              itemType: 'High Jump Boots',
              itemId: 1,
              location: lOTGM2[2],
              checked: false));
      Hive.box('MetroidII').put(
          "Spring Ball",
          Item(
              itemType: 'Spring Ball',
              itemId: 1,
              location: lOTGM2[3],
              checked: false));
      Hive.box('MetroidII').put(
          "Varia Suit",
          Item(
              itemType: 'Varia Suit',
              itemId: 1,
              location: lOTGM2[4],
              checked: false));
      Hive.box('MetroidII').put(
          "Space Jump",
          Item(
              itemType: 'Space Jump',
              itemId: 1,
              location: lOTGM2[5],
              checked: false));
      Hive.box('MetroidII').put(
          "Screw Attack",
          Item(
              itemType: 'Screw Attack',
              itemId: 1,
              location: lOTGM2[6],
              checked: false));
      Hive.box('MetroidII').put(
          "Ice Beam",
          Item(
              itemType: 'Ice Beam',
              itemId: 1,
              location: lOTGM2[7],
              checked: false));
      Hive.box('MetroidII').put(
          "Wave Beam",
          Item(
              itemType: 'Wave Beam',
              itemId: 1,
              location: lOTGM2[8],
              checked: false));
      Hive.box('MetroidII').put(
          "Spazer Beam",
          Item(
              itemType: 'Spazer Beam',
              itemId: 1,
              location: lOTGM2[9],
              checked: false));
      Hive.box('MetroidII').put(
          "Plasma Beam",
          Item(
              itemType: 'Plasma Beam',
              itemId: 1,
              location: lOTGM2[10],
              checked: false));
    }
    if (Hive.box('SuperMetroid').isEmpty) {
      List<String> lMSM = [
        'Located in the main shaft in the room just below the only save room.',
        'Located on a pillar heading between Samus\'s ship and the Wrecked Ship. Requires the Grapple Beam.',
        'Located at the very bottom of the main shaft, go right one room and on the left side use Bombs.',
        'Located in the wall at the very top of the large area dividing Crateria and Wrecked Ship, requires either the Ice Beam or Speed Booster.',
        'In the morph ball maze in the middle of the large area between Crateria and Wrecked Ship, go left. Requires Super Missiles.',
        'At the bottom of the large area between Crateria and Wrecked Ship, in the water. Go left, and blow up the wall. Requires the Gravity Suit.',
        'In the area with Samus\'s ship, shinespark up to the top left side. Pass through "The Gauntlet" and at the very end, drop down and shoot the wall on the left and fall in.',
        'In the same room as missile 7, go right instead of left.',
        'After getting the Morph Ball, go right, and then drop down in the room with the blocks.',
        'Go up from the previous missile and head right, then go to the end of the hall.',
        'From the western elevator from Crateria, take the first door on the right, then use bombs on the lower level.',
        'Take the lower right door from the western elevator, proceed into the next area, and use either wall jumps or the Grapple Beam to the left just below.',
        'Located in the bottom left corner of the same room as above.',
        'In the long green corridor, look for a single pipe in the top right. Use either the Hi-Jump Boots or wall jump trick to get up there and crawl through.',
        'Right above missile 11, use the Speed Booster to make it past the shutters before they close and continue right.',
        'Blow up the wall behind missile 15.',
        'Back in Eastern Brinstar, above missile 10, use the Screw Attack at the top of the long vertical shaft (accessible by Speed Booster or Space Jump), and then use the Gravity Suit in the next room to climb up.',
        'To the left of missile 17, hidden in the bottom left block of the pedestal.',
        'In the room where you acquire Power Bomb 2, use one on the left wall.',
        'In the first long corridor leading to Kraid\'s room, near the hidden Save room, use a Power Bomb and the Spring Ball to get into the tunnel.',
        'After getting the Hi-Jump Boots, climb up.',
        'Right of the elevator in the green-colored room, go to the bottom right and shoot out the floors, and jump to the left.',
        'Just outside the Speed Booster room, shoot up at the roof.',
        'On the opposite corner of the green room containing missile 22, go through the left Super Missile door using the Grapple Beam, and jump across.',
        'Just behind that, shoot down to reveal a pillar. Place a bomb at the top and go through into the hidden room. Shoot the leftmost green block.',
        'In the room with the shutters left of the elevator, use the Speed Booster, and at the end place a Power Bomb. Drop down, and shoot the left wall just past the door.',
        'In the large vertical shaft below Power Bomb 7, leading towards the Grapple Beam, drop down and take the door on the right.',
        'Climb straight up from Crocomire\'s room, and use the Grapple Beam in this large room to get to the top left.',
        'Located just outside the Wave Beam room.',
        'Located in the lava in the third pit in the second room to the right of the elevator. Can be done with or without the Gravity Suit.',
        'To the right of the Grapple Beam, use either Shinespark from the lower right or the Grapple Beam on Rippers from the upper left to get to the upper right corner.',
        'Upon entering Ridley\'s Lair, head left, down, and then right. When you see the missile, Space Jump across to avoid falling.',
        'After defeating the yellow Chozo Statue, continue down the passage to the right all the way down. At the end, go up, and shoot out the roof, and head left. Crawl through the passageway on the left side of this room.',
        'After the large room that fills with lava, go right, up, left, up, and then right.',
        'After the above missile, go left. Use a Power Bomb before going up the shaft.',
        'At the Save Room in this area, go down, and just to the left of the first door on the right, use a bomb at the corner of the wall.',
        'Turn the power on by defeating Phantoon, and then head up to the top of the main shaft. Go right.',
        'Immediately to the right of the Gravity Suit room, use bombs on the floor. Knock the robots into the pits in the next room.',
        'Requires the Speed Booster and knowledge of Shinesparking. Above the room with the pipe that you shattered, activate the speed booster going into this room, and prepare a shinespark before entering. You should see two plants in the foreground on the floor. Stand behind the left and jump straight up.',
        'In the large central room that the pipe passes through, get on the lowest level and Speed Boost to the right. Ready a Shinespark, and use it below the first gap in the roof from the right.',
        'Just before fighting Draygon, go to the top right of that room and shoot at the wall just past the spikes.',
        'From the room with the pipe, exit left and then go up. After going through the door in the ceiling, go right.',
        'After the previous missile, go up and left and continue to the end. The dead-end is fake.',
        'In the room with the pipe, go to the bottom right and blow open the floor. Drop through the sand on the right side, then go to the top left corner of the next room.',
        'In the same area as above, fall through the left sandpit instead. The Space Jump and Spring Ball are required to get this. It is in the top left again.',
        'From the glass pipe that was shattered, go up into the next room and take the second door to the right. Go to the bottom right and jump through the fake wall, and shoot along the right wall, about halfway up.',
      ];
      List<String> lESM = [
        'Proceed left down the tunnel from Samus\'s ship and you\'ll walk right into it.',
        'Located in "The Gauntlet," above and to the left of Samus\'s ship, proceed about halfway down.',
        'To the left of Kraid, just before climbing up towards the Norfair elevator, go into the room that was previously sealed. Defeat the enemies here, and then shoot at the roof on the left side.',
        'Below the main elevator shaft, go all the way down and use a Power Bomb. Descend to the bottom again, and go left. When you see the Energy Tank, jump into it, there\'s a hole in front of it.',
        'To the right of the Morph Ball and the left of Missile 2, shoot out the ceiling to reveal this. Use Hi-Jump or bomb jumps to reach it.',
        'In the large purple shaft of this area, open the Power Bomb door and head right. Requires the Wave Beam.',
        'In the room that held the Charge Beam, plant a Power Bomb and continue below. Proceed to the end of the corridor. Requires Speed Booster and Gravity Suit.',
        'Located in front of the Hi-Jump Boots, at the bottom of the elevator shaft on the left.',
        'Located at the right end of Crocomire\'s boss room. Requires the Grapple Beam.',
        'After the room that slowly fills with lava, go right and defeat the dragon head, and walk past it. Proceed down into a spiked area and go towards the right side.',
        'Right after beating Ridley, go into the next room and shoot below the door.',
        'From the entrance from Maridia, go into this first yellow room and shoot up. Use the Grapple Beam to get across the water in the following room.',
        'After defeating the serpent Botwoon, proceed right into the purple corridor with sand pits. You\'ll see this Energy Tank, go to the right side and jump up into the passage. Be careful of the hole in front.',
        'In the room with turtles that contained Missile 46. Located at the top, above a Grapple Beam block.',
      ];
      List<String> lSSM = [
        'In the large vertical drop in Old Tourian, look for a platform against the right wall near the bottom. Use a bomb here. Open the door and run to the end of the hall to activate the Speed Booster, then shinespark up to the top. Freeze the enemies against the floor before running.',
        'Acquired after defeating Spore Spawn.',
        'In the first room right of the main elevator, get through the shutters with the Speed Booster, but instead of going through the door shoot the ceiling. Go up and left.',
        'Located within the room just behind Energy Tank 4.',
        'After getting the Screw Attack, turn around and use it in the room you just came from right as you enter.',
        'Defeat Phantoon, then climb back up the shaft and take the first door on the left.',
        'Come back out from that Super Missile, go to the opposite wall, and plant a bomb. Power Bomb the end of the next room, and take the second entrance from the bottom.',
        'In the massive underwater shaft, go to the top right room. Along the left wall, go into the small tunnel.',
        'After missile 40, go right. Jump over the hidden crumbling blocks.',
        'Located on the other side from missile 43.'
      ];
      List<String> lPSM = [
        'Shinespark up-right next to Samus\'s ship, and open the door with a Power Bomb.',
        'At the top of the red shaft, go right, drop down by shooting the floor, and open the Super Missile door.',
        'Above that Power Bomb, go up and open the other Super Missile door and Power Bomb the floor close to the left edge.',
        'In the long green corridor past the Charge Beam, use the Hi-Jump to get up to the opposite door, and use a Power Bomb to get in. Plant a bomb at the base of the wall.',
        'Below Energy Tank 4, go right, and reach a very tall shaft. Etecoons will teach you how to wall jump, follow their lead up to the top, and go into the tunnel.',
        'In the purple shaft, cross the Grapple Beam blocks, and then Power Bomb the wall. In the next room, look for the hidden block and use a Super Missile on it.',
        'To the left of Crocomire, use the Ripper as a Grapple Beam point and cross to the missile door.',
        'Before planting the Power Bomb needed to go down towards Ridley\'s room, go to the left wall and plant the bomb there, instead. Go through the revealed tunnel.',
        'After missile 34, plant a bomb in the top corner. Use the Spring Ball to get inside, then hold A and right to get through without falling. Go through the door at the end.',
        'Located in the same room as missile 44, on the right side. Space Jump/Spring Ball will make this easier.'
      ];
      List<String> lOTGSM = [
        "Located immediately left of the first entrance to Brinstar.",
        'Located in the first tunnel of the game in Crateria, past a Morph Ball hole. Guarded by the Statue.',
        'Upon entering the purple section of Brinstar, drop down to the bottom of the main room, and blow up a block near the bottom.',
        'After entering Norfair, drop to the bottom and go left. Blow up the floor and roll through into the next room.',
        'At the bottom of the red shaft in Brinstar, go right two rooms, then climb up and go through the door.',
        'Acquired after defeating Kraid.',
        'Located at the top right of Norfair, head to the top right of the green room (go around from below) and shoot the blocks on the ceiling. Climb up and proceed.',
        'Just left of the Norfair elevator, use the Speed Booster and run to the end. Proceed, and at the top place a bomb to drop in to a tunnelway.',
        'After beating Crocomire, go left, down, down, and left through the large room.',
        'Behind the Power Bomb door in the red shaft in Brinstar, requires the Grapple Beam.',
        'From the green room in Norfair, take the middile right door, then the first door on the right to get into a large room. Use the Grapple Beam and platforms to get to the top right ledge.',
        'Located in the western portion of Wrecked Ship. Climb onto the empty Chozo Statue as a morph ball, and it will carry you down. Requires beating Phantoon first.',
        'Acquired after defeating Draygon in Maridia.',
        'Located in the upper orange section of Maridia, requires the Space Jump. Go to the top right of the room with the top entrance of the big pipe.',
        'Requires the Space Jump first. Located to the right of the large sandpits at the bottom of Maridia. Use the Grapple Beam on the block in the first room and jump up and over. Lay a Power Bomb in the dead-end room with the robot.',
        'Located in Ridley\'s Lair right after the second Chozo Statue fight.',
      ];
      List<String> lRSM = [
        'Located in the first door on the right of the main elevator. Requires the Speed Booster.',
        'Located in the same room as missile 25, at the top left of the green room.',
        'After the Gravity Suit and missile 38, go right and plant a Power Bomb. Activate the Speed Booster going right, and shinespark up at the end of the hall into the opening. Drop down through the left side of the floor and go left (over the hole).',
        'Located in the same room as missile 45.'
      ];
      for (int i = 1; i < 47; i++) {
        Hive.box("SuperMetroid").put(
            "Missiles $i",
            Item(
                itemType: "Missiles $i",
                itemId: i,
                location: lMSM[i - 1],
                checked: false));
        if (i <= 14) {
          Hive.box("SuperMetroid").put(
              "Energy Tank $i",
              Item(
                  itemType: "Energy Tank $i",
                  itemId: i,
                  location: lESM[i - 1],
                  checked: false));
          if (i <= 10) {
            Hive.box("SuperMetroid").put(
                "Super Missiles $i",
                Item(
                    itemType: "Super Missiles $i",
                    itemId: i,
                    location: lSSM[i - 1],
                    checked: false));
            Hive.box("SuperMetroid").put(
                "Power Bombs $i",
                Item(
                    itemType: "Power Bombs $i",
                    itemId: i,
                    location: lPSM[i - 1],
                    checked: false));
            if (i <= 4) {
              Hive.box("SuperMetroid").put(
                  "Reserve Tank $i",
                  Item(
                      itemType: "Reserve Tank $i",
                      itemId: i,
                      location: lRSM[i - 1],
                      checked: false));
            }
          }
        }
      }
      Hive.box('SuperMetroid').put(
          'Varia Suit',
          Item(
              itemType: 'Varia Suit',
              itemId: 1,
              location: lOTGSM[5],
              checked: false));
      Hive.box('SuperMetroid').put(
          'Gravity Suit',
          Item(
              itemType: 'Gravity Suit',
              itemId: 1,
              location: lOTGSM[11],
              checked: false));
      Hive.box('SuperMetroid').put(
          'Morph Ball',
          Item(
              itemType: 'Morph Ball',
              itemId: 1,
              location: lOTGSM[0],
              checked: false));
      Hive.box('SuperMetroid').put(
          'Bombs',
          Item(
              itemType: 'Bombs',
              itemId: 1,
              location: lOTGSM[1],
              checked: false));
      Hive.box('SuperMetroid').put(
          'Spring Ball',
          Item(
              itemType: 'Spring Ball',
              itemId: 1,
              location: lOTGSM[14],
              checked: false));
      Hive.box('SuperMetroid').put(
          'Screw Attack',
          Item(
              itemType: 'Screw Attack',
              itemId: 1,
              location: lOTGSM[15],
              checked: false));
      Hive.box('SuperMetroid').put(
          'Hi-Jump Boots',
          Item(
              itemType: 'Hi-Jump Boots',
              itemId: 1,
              location: lOTGSM[3],
              checked: false));
      Hive.box('SuperMetroid').put(
          'Space Jump',
          Item(
              itemType: 'Space Jump',
              itemId: 1,
              location: lOTGSM[12],
              checked: false));
      Hive.box('SuperMetroid').put(
          'Speed Booster',
          Item(
              itemType: 'Speed Booster',
              itemId: 1,
              location: lOTGSM[6],
              checked: false));
      Hive.box('SuperMetroid').put(
          'Grapple Beam',
          Item(
              itemType: 'Grapple Beam',
              itemId: 1,
              location: lOTGSM[8],
              checked: false));
      Hive.box('SuperMetroid').put(
          'X-Ray Scope',
          Item(
              itemType: 'X-Ray Scope',
              itemId: 1,
              location: lOTGSM[9],
              checked: false));
      Hive.box('SuperMetroid').put(
          'Charge Beam',
          Item(
              itemType: 'Charge Beam',
              itemId: 1,
              location: lOTGSM[2],
              checked: false));
      Hive.box('SuperMetroid').put(
          'Ice Beam',
          Item(
              itemType: 'Ice Beam',
              itemId: 1,
              location: lOTGSM[7],
              checked: false));
      Hive.box('SuperMetroid').put(
          'Wave Beam',
          Item(
              itemType: 'Wave Beam',
              itemId: 1,
              location: lOTGSM[10],
              checked: false));
      Hive.box('SuperMetroid').put(
          'Spazer Beam',
          Item(
              itemType: 'Spazer Beam',
              itemId: 1,
              location: lOTGSM[4],
              checked: false));
      Hive.box('SuperMetroid').put(
          'Plasma Beam',
          Item(
              itemType: 'Plasma Beam',
              itemId: 1,
              location: lOTGSM[13],
              checked: false));
    }
    if (Hive.box("Fusion").isEmpty) {
      List<String> lMMF = [
        'In the ventilation shafts after acquiring Missiles, drop down towards the bottom, and after passing the wires go right.',
        'After missile 1, go left. Shoot the corner blocks on the left wall.',
        'To the left of the first Nav Room, go up the shaft and through the Morph Ball hole on the right.',
        'To the left of the main elevator, use the Speed Booster to run into the hole in the wall and through the left side of that room.',
        'On the Habitation Deck, drop through the center set of rooms to the bottom floor.',
        'After getting trapped in the main elevator, go until you reach a room with purple walls. Plant a Power Bomb here.',
        'On the right side of the Central Reactor Core area, find this expansion hidden on the left side in the Morph Ball tunnels.',
        'In the last atmospheric stabilizer room before the boss room, take the top left door and walk past the water.',
        'After acquiring the Charge Beam, go to the top right exit, and shoot the roof in the next room. Shoot missiles near the top left wall to unveil a passage.',
        'In the right-most Save Room, shoot the right wall. Use Space Jump or wall jumps to get to the top left.',
        'In the lava-filled room, get to the top-left corner. Requires the Space Jump.',
        'In the lava-filled room, get to the center platform.',
        'In the lava-filled room, get to the bottom left corner. Requires the Gravity Suit.',
        'To the right of the Data Room, climb up and use bombs at the base of the wall.',
        'From that same room, go to the bottom left corner and plant a bomb. Go down and then through the left door. Jump up to the left and place a bomb on the one raised block. Shoot the wall to the left above the top of the pillar.',
        'Below that missile, go all the way down to the bottommost room, and at the bottom of that room, bomb the lower right corner and head into the tunnel.',
        'To the right of and above that area, left of the SA-X encounter room, you\'ll find a room filled with water. Climb up to the top left using the ladder.',
        'In that same room, go down into the water. Bomb the ground to reveal a pillar, and go into the left room. Bomb the ground to reveal another pillar and use the Jumpball to get up to the top left and bomb the wall. Easier with the Gravity Suit, but not necessary.',
        'Above the shaft that led to the above room, use some bombs to get up to the top and go right. In the second room, climb up to the second tunnel and roll in and plant a bomb.',
        'In the large green room at the entrance to this sector, go through the blue door and bomb the right wall.',
        'From that same room go through the middle left entrance. Jump over the pillar with Hi-Jump.',
        'Located to the right of the room where you acquired the Hi-Jump. Requires Screw Attack, Space Jump. Drop down into this room and plant a Power Bomb, then Speed Boost and Shinespark through to get the missile.',
        'In the first large red room, drop to the bottom. Activate the Speed Booster from the right edge going left, and break through the next room. Shoot out the floor just past the first hump, drop in and shoot the right roof.',
        'At the top of the long red shaft containing dragon heads, go left. Blow up the second tunnel in this room and go through.',
        'After downloading Super Missiles, go back to the Save/Recharge rooms just below, and go to the room on the right. Use Super Missiles on the creature blocking the way.',
        'Climb up above where the Security Robot escaped to, and activate the Speed Booster in this corridor. Just before you reach the hole, duck and Shinespark up-left.',
        'Go to the very bottom of the shaft with dragon heads and go right. Shoot the top center block of the middle structure.',
        'Requires the Space Jump. From the room above, use bombs on the lower right corner. Get up to the top right corner of the large room beyond here and the crawl left.',
        'In the first room of Sector 3, take the middle left entrance. Cross this lava-filled room and go into the next.',
        'In the second large room with electrified water, climb up above the door and bomb to reveal a ladder. Cross in and go up, then take the left tunnel.',
        'Above the first electrified chamber, or after defeating Serris, climb into this room and go up the right side. Use bombs in the top left alcove and crawl through. Plant more bombs along the bottom left.',
        'In the same room take the left side instead of the right. Jump up and to the right and shoot the wall.',
        'Located right below the Pump Control Station after lowering the water.',
        'Back in the room containing missile 30, run right at the bottom and Speed Boost through the wall.',
        'Entering from Sector 5, Shinespark to the top right, then take the second door on the right. Get through the next corridor and reach the end.',
        'In the same shaft, take the bottom right exit, and plant a power bomb in the glass tube.',
        'In the rightmost part of the corally areas, next to the lower right Save Room, take the top right exit. Run until you reach a pillar, then Speed Boost back left through the door. Take the next door, and Speed Boost to the end, but Shinespark towards the roof opening. Drop left and grab the ledge.',
        'Go left of the Diffusion Missile Data Room, and kill the Super Missile-vulnerable creature. Bomb the left underneath the electrical conduit.',
        'After getting Ice Missiles, drop down and go right at the bottom. Climb the next chamber (using your new Ice Missiles) and shoot the roof.',
        'Right from the entrance area, go down and through the yellow door. Kill the creature there and shoot the top right corner.',
        'After Nightmare breaks loose, in the large chamber to the right of the entrance, take the top left exit. Requires the Space Jump.',
        'Located behind the yellow door opposite missile 40. There is a hidden entrance left of the missile.',
        'In the first dark chamber, bomb the lower left wall.',
        'Below the Save Room after the SA-X encounter, shoot out the blocks and plant a bomb at the bottom left corner. In the next room, get up to the top left and plant a bomb in the alcove.',
        'After getting the Varia Suit, go right two doors and climb all the way up. Take the left door.',
        'As you grab the previous missile, hold left and grab the ledge on your way down. Shoot the roof in the next room',
        'Past the first darkened room, you\'ll find a tall shaft leading down. Take the first door on the right, and at the end of the Blue X chamber, defeat the fake missile expansion. Bomb the wall to find the real one.',
        'After defeating the security robot, go right and shoot the shutter with your new Wave Beam.',
      ];
      List<String> lEMF = [
        'Plainly acquired just before fighting Arachnus X.',
        'Just past that Energy Tank, aim up and shoot a missile or two at the ceiling right before dropping down the hole. Climb up and over for another.',
        'Plainly acquired while exploring the Central Reactor Core.',
        'In the room right of the first atmospheric stabilizer, you\'ll see a small gray tunnel. Enter from the left with Morph Ball.',
        'After returning to Sector 1 via the Restricted Zone, climb up the next shaft. Before dropping down, shoot a charged Diffusion Missile at the wall on the right.',
        'In the room that contained the Charge Beam, activate the Speed Booster and Shinespark from the lower left corner straight up.',
        'Plainly acquired just before getting the Hi-Jump Boots/Jumpball.',
        'In the shaft left of the boss containing the Plasma Beam, go up, and at the top go right. Jump up at the wall to find a hidden tunnel.',
        'Requires Space Jump/Screw Attack. From the Lv1 Security Room, Screw Attack through the top left wall. In the next room, keep Space Jumping to avoid getting caught in the crumbling blocks and get to the top left.',
        'After "defeating" the Security Robot, climb up and then go left. Speed Boost, and jump just after going through the door, or Shinespark through the door. Plant a bomb at the bottom left.',
        'Located just before missile 28.',
        'Left of missile 29, use bombs. Speed Boost into the next room and Shinespark up at the end. Use the Space Jump, or shoot the wall and bomb the lower left corner to reveal a pillar to climb up there.',
        'From the first room with electrified water, take the top left door and from there take the top left door again. Go through this winding segment and get to the top.',
        'After releasing Lv4 Security, go right and climb up. Look for an alcove on the right and roll in. Lay a Power Bomb. Avoid any X that appear, and let them form into yellow crabs. Defeat them and then go through the door. Lay another Power Bomb to reveal the path.',
        'After getting Ice Missiles, drop into the shaft on the right. Freeze a ripper and go into the door on the left ledge. Defeat the fake Energy Tank and bomb the wall again.',
        'Located right before Nightmare. Use a Power Bomb to reveal the path instead of going to it directly.',
        'While heading towards Nightmare, you\'ll come across a tall underwater shaft. Come back here after getting the Gravity Suit, and look for a hole on the right side. Directly opposite that, plant a bomb on the left wall. Watch out for crumbling blocks, and don\'t lay any bombs in this room.',
        'In the first darkened room, bomb the lower right corner just between the rocks. In this room, bomb the upper wall to reveal a path.',
        'From the second large darkened room, take the bottom left exit. Speed Boost through the wall at the end, drop, and go left.',
        'From the tall shaft after the first darkened room, take the middle left exit. Use the Screw Attack and Power Bomb to destroy each obstacle, then Speed Boost heading right. Shinespark right after going through the door. In the next room bomb the respective parts of each platform: center, center, left and right ends, center. Speed Boost/Shinespark up to the top right.'
      ];
      List<String> lPMF = [
        'After the elevator gets stuck, once you drop below the frozen room, plant a Power Bomb, and head left. Lay another Power Bomb if necessary.',
        'In the Restricted Zone, activate the Speed Booster and Shinespark straight up in the glass chamber. Only accessible after the Restricted Lab is jettisoned, accessible via Sector 6.',
        'Once you\'ve acquired Power Bombs and opened Lv2 Security Doors, head up towards the Habitation Deck and use a Power Bomb on the green creature. Jump up to the hidden tunnel on the right.',
        'After entering from the Restricted Lab, just before the first Save Room, shoot the floor. Defeat the creature to the left, let it reform, defeat the Zebesian, then go right.',
        'Below the room containing the Charge Beam, go into the Save Room. Activate the Speed Booster going right, and when you enter the rocky area, store a Shinespark. Drop into the water, go right, then Shinespark up.',
        'From the first room, take the green door in the top right. Use the Screw Attack to break through the ceiling, and go up.',
        'In the large blue central room with no vegetation, Space Jump up to the center and shoot the walls on the right.',
        'From that room, take the left exit, then go up and left through the tunnel and door. Freeze the rippers to use as platforms over the crumbling blocks and get to the top left.',
        'Shoot straight down below the previous Power Bomb.',
        'Located in the same crumbling block room below Energy Tank 9.',
        'In the same room as Missile 22, requires some skill with the Speed Booster.',
        'Just left of Energy Tank 10, left of the Security Robot. Plant a Power Bomb to reveal the tunnel at the top.',
        'From the first room, go to the bottom floor and Speed Boost right. After you fall through the floor, go left and plant a Power Bomb.',
        'From the tall red shaft with dragons, take the bottom left exit. Requires the Gravity Suit. Go left and get into the next room, go to the bottom left, and plant a Power Bomb. Navigate this room.',
        'From the same shaft, go right. Drop into the lava and Screw Attack in the lower right corner. Run back, then Speed Boost into the next room and Shinespark straight up.',
        'After collecting the previous Power Bomb, drop back down and hold left to climb onto another ledge. Screw Attack above the ledge and Screw Attack again coming down in the hidden area.',
        'From the left middle exit of the first room, use the Screw Attack along the floor in the last room. Go left, and in the access tunnel, use missile in the ceiling corner. Alternatively, come in from the Sector 5 side.',
        'After entering the coral area from Sector 5, go through the tunnel on the left side across from the second door on the right.',
        'Go to the bottom of the same shaft, go left, and use a Power Bomb and missiles to blow out the top of the green tube. Get up to the top right corner and shoot to reveal a tunnel.',
        'Located on the way to missile 37. Go right after Shinesparking before dropping down.',
        'From the main elevator of Sector 4, go left into the first room with electrical conduits. Just after the door, plant a bomb at the base of the wall. Drop in, go the left corner, and plant a Power Bomb.',
        'After the SA-X encounter in this area, plant a Power Bomb in the lower left corner of the next room to gain access.',
        'In the same room, climb up next to the door, lay another Power Bomb, and then climb up higher by freezing rippers. At the top, go through the door.',
        'In the giant frozen room, left of the Data Room, plant a Power Bomb near where the creature is and go into the next room. Try to freeze rippers above the crumbling blocks in this area to create stepping stones.',
        'Located behind missile 41. Shinespark through the door to open the wall behind the missile.',
        'After Nightmare breaks loose, take the door to the top right of the once-frozen room. Instead of going through the door in this room (to Sector 3), use a Power Bomb to reveal the hidden blocks in the ceiling. Climb up and open the shutters and bomb your way in.',
        'On the way to Nightmare, after shooting through the ceiling in the room past the water, go left through the open door.',
        'Outside the Save Room just before Nightmare, lay a Power Bomb to reveal a tunnel leading to a Recharge room. In this tunnel, lay another Power Bomb. Jump up to find a hidden tunnel.',
        'After getting the Gravity Suit, run to the right in the watery rooms below, and activate the Speed Booster. Right in between the two walls you run through, Shinespark straight up.',
        'Opposite Energy Tank 20, use the Speed Booster and store a Shinespark heading left. Open the door, then Shinespark through. In the next room, you\'ll fly right past this upgrade. From the bottom floor, run right until you pass the fifth pillar, then Shinespark up.',
        'In the same room, charge a Shinespark from the bottom left to the bottom right, then jump up and Shinespark into the slope above. Quickly jump to the left before running onto the straight platform. Jump a second time and you should fly right into the box.',
        'In the room where you previously dropped down to fight the Security Robot, Screw Attack to the right instead of dropping down. Through the door, plant a Power Bomb, and roll up in the top right tunnel. Spam standing up and jumping on the crumbling blocks and you should grab the ledge.',
      ];
      List<String> lOTGMF = [
        'Located in the Main Deck Data Room. You will be directed here by the Nav room.',
        'Leaving the operations room, descend through the ventilation shaft and defeat Arachnus X.',
        'Finish clearing the atmospheric stabilizers in area 1, then head for the central room and defeat the Core X there.',
        'After unlocking Level 1 Security, move to the Sector 2 Data Room for this download.',
        'Deep down on the lower right corner of Sector 2, defeat the boss there.',
        'Defeat Serris in Sector 4 in the top part of the map.',
        'Download this in the Sector 3 Data Room.',
        'Get down to the Sector 6 Data Room, and defeat the Core X boss in the room to the right to reclaim the upgrade.',
        'Download in the Sector 5 Data Room after unlocking Level 3 Security.',
        'Acquired from the Core X in the Main Boiler of Sector 3.',
        'Download in the Sector 5 Data Room (required before getting any upgrades).',
        'Acquired after defeating Mecha Spider X in the Central Reactor Core area.',
        'Going into Sector 2 via the Reactor Silo, defeat the plant like creature you\'ll eventually come to.',
        'Acquired by beating Nightmare in Sector 5.',
        'Download in the Sector 4 Data Room, after unlocking Level 4 Security and acquiring the Gravity Suit.',
        'Acquired by beating the Security Robot in Sector 6.',
        'After reentering Sector 1 from the Restricted Zone, defeat Ridley X.',
        'Acquired after defeating SA-X at the very end of the game.'
      ];
      for (int i = 1; i <= 48; i++) {
        Hive.box('Fusion').put(
            "Missiles $i",
            Item(
                itemType: "Missiles $i",
                itemId: i,
                location: lMMF[i - 1],
                checked: false));
        if (i <= 32) {
          Hive.box('Fusion').put(
              "Power Bomb $i",
              Item(
                  itemType: "Power Bomb $i",
                  itemId: i,
                  location: lPMF[i - 1],
                  checked: false));
        }
        if (i <= 20) {
          Hive.box('Fusion').put(
              "Energy Tank $i",
              Item(
                  itemType: "Energy Tank $i",
                  itemId: i,
                  location: lEMF[i - 1],
                  checked: false));
        }
      }
      Hive.box('Fusion').put(
          'Missile Launcher',
          Item(
              itemType: 'Missile Launcher',
              itemId: 1,
              location: lOTGMF[0],
              checked: false));
      Hive.box('Fusion').put(
          'Morph Ball',
          Item(
              itemType: 'Morph Ball',
              itemId: 1,
              location: lOTGMF[1],
              checked: false));
      Hive.box('Fusion').put(
          'Charge Beam',
          Item(
              itemType: 'Charge Beam',
              itemId: 1,
              location: lOTGMF[2],
              checked: false));
      Hive.box('Fusion').put(
          'Morph Ball Bombs',
          Item(
              itemType: 'Morph Ball Bombs',
              itemId: 1,
              location: lOTGMF[3],
              checked: false));
      Hive.box('Fusion').put(
          'Hi-Jump/Jumpball',
          Item(
              itemType: 'Hi-Jump/Jumpball',
              itemId: 1,
              location: lOTGMF[4],
              checked: false));
      Hive.box('Fusion').put(
          'Speed Booster',
          Item(
              itemType: 'Speed Booster',
              itemId: 1,
              location: lOTGMF[5],
              checked: false));
      Hive.box('Fusion').put(
          'Super Missile',
          Item(
              itemType: 'Super Missile',
              itemId: 1,
              location: lOTGMF[6],
              checked: false));
      Hive.box('Fusion').put(
          'Varia Suit',
          Item(
              itemType: 'Varia Suit',
              itemId: 1,
              location: lOTGMF[7],
              checked: false));
      Hive.box('Fusion').put(
          'Ice Missile',
          Item(
              itemType: 'Ice Missile',
              itemId: 1,
              location: lOTGMF[8],
              checked: false));
      Hive.box('Fusion').put(
          'Wide Beam',
          Item(
              itemType: 'Wide Beam',
              itemId: 1,
              location: lOTGMF[9],
              checked: false));
      Hive.box('Fusion').put(
          'Power Bomb',
          Item(
              itemType: 'Power Bomb',
              itemId: 1,
              location: lOTGMF[10],
              checked: false));
      Hive.box('Fusion').put(
          'Space Jump',
          Item(
              itemType: 'Space Jump',
              itemId: 1,
              location: lOTGMF[11],
              checked: false));
      Hive.box('Fusion').put(
          'Plasma Beam',
          Item(
              itemType: 'Plasma Beam',
              itemId: 1,
              location: lOTGMF[12],
              checked: false));
      Hive.box('Fusion').put(
          'Gravity Suit',
          Item(
              itemType: 'Gravity Suit',
              itemId: 1,
              location: lOTGMF[13],
              checked: false));
      Hive.box('Fusion').put(
          'Diffusion Missile',
          Item(
              itemType: 'Diffusion Missile',
              itemId: 1,
              location: lOTGMF[14],
              checked: false));
      Hive.box('Fusion').put(
          'Wave Beam',
          Item(
              itemType: 'Wave Beam',
              itemId: 1,
              location: lOTGMF[15],
              checked: false));
      Hive.box('Fusion').put(
          'Screw Attack',
          Item(
              itemType: 'Screw Attack',
              itemId: 1,
              location: lOTGMF[16],
              checked: false));
      Hive.box('Fusion').put(
          'Ice Beam',
          Item(
              itemType: 'Ice Beam',
              itemId: 1,
              location: lOTGMF[17],
              checked: false));
    }
    if (Hive.box('ZeroMission').isEmpty) {
      List<String> lMZM = [
        'Found in plain sight leading towards Norfair.',
        'From the second shaft, take the Missile door going right. After the two corridors, in the large room, jump up into the top left corner.',
        'From there, go right through two doors and shoot out the bottom corner of the wall in front of you.',
        'After getting Bombs, crawl below the platform and bomb to get through. Climb up through the next room using bombs.',
        'Return to the main shaft, and look for a small alcove along the left wall just below the door on the right. Climb into there (easier with the Power Grip) and bomb the floor. Drop through the crumbling blocks.',
        'Below and right of the spawn, in the shaft leading to Kraid\'s Lair, bomb the lower left corner to reveal a Morph Ball Launcher. Climb in and hold right at the top.',
        'After getting the Ice Beam, climb to the top of the second shaft by freezing enemies and go left through the hole.',
        'On the way to Super Missile 1, press Down after punching through the first Speed Booster blocks to stop, and jump up.',
        'After getting the Varia Suit, drop down and go right, past the Save Room.',
        'In the room below missile 2, shoot out the floor. In the room below, use a bomb next to the Missile Tank to open it up and climb in. Usually requires the Power Grip, unless you\'re really good.',
        'From the elevator from Norfair, go right into the water, and break the blocks leading into the lower left',
        'In the same room as Unknown Item #1, blow up the block in the way.',
        'After recovering the complete Power Suit, Power Bomb through the upper door between Crateria and Chozodia into the open-air area, and charge up a Shinespark into that door. Crouch immediately, drop to the ledge below, and Shinespark left in Morph Ball.',
        'From the elevator from Brinstar, go left until you see the protrusion at the top. Usually requires the Power Grip.',
        'From that missile, go further left, then go down and right.',
        'In the chamber below the Ice Beam room, shoot the rocks preventing a creature from jumping up. Freeze the creature and use it as a platform to get above.',
        'From the Ice Beam room, go left, then up, then right. In the room past the Chozo Statue, shoot the top right wall.',
        'At the top of the green shaft at the far right (above the Ice Beam room), take the highest door into the super-heated chamber. Requires the Varia Suit.',
        'After getting the Hi-Jump Boots, return to the shaft on the right and jump into the top right corner.',
        'Located just before Super Missile 3. Go to the tunnel above the one containing the Hi-Jump boots and go left. At the last column, climb to the top.',
        'Further behind Super Missile 4. Extremely difficult to acquire without the Space Jump.',
        'Right of the Map Room, go down and right. Past that cavern in the next shaft, go down and right again. Look near the ceiling.',
        'Located at the end of the same room as above.',
        'In the room with the two caterpillars, after defeating them (Wave Beam and Bomb to the underbelly, respectively) use this room to build up Speed Booster charge heading right towards the shaft.',
        'Located to the right of the Screw Attack.',
        'Once you have the Gravity Suit, go towards Power Bomb 2. In the shaft immediately preceding it in the lava, go up and lay a Power Bomb.',
        'Upon entering from the main elevator, take the first left, but roll through the hidden tunnel in the left wall.',
        'Upon entering from the main elevator, take the first right.',
        'From that missile, go further right, then use the Morph Ball Launcher to go up. At the top, roll through the tunnels.',
        'After defeating the Acid Worm and draining the acid, shoot the middle of the floor to break through to another chamber. Shoot the top left wall here.',
        'After activating the Zip Lines, take the exit below the first save room. At the end of the corridor, go up and around.',
        'In the room below that missile, use bombs on the floor. Proceed into the next few corridors and in the long one, activate each of the Morph Ball Launchers in order.',
        'At the shaft right of Kraid\'s boss room, climb up and take the second highest door on the left. Shoot the wall at the end.',
        'From the main elevator, drop down and take the third door on the left. On top of the floating platform in this room, plant one bomb in the center, then immediately roll left and plant another bomb. Get grabbed by the zip line and drop down when you are above the missile tank.',
        'Once you have the Gravity Suit, take the second door left from the elevator, and go down into the second acid pit and break the blocks and Morph Ball Shinespark right at the end of the hall.',
        'In the farthest left shaft, behind Energy Tank 7, drop past the save room and roll through the tunnels.',
        'Further below that, go right into a very long hallway. In the ceiling, you\'ll find an open space you can run in. Charge up a Shinespark heading left up there, then drop down and Shinespark into the slope by the door. Keep running through here back into the shaft and drop down. Shinespark to the top in the left side of this chamber, and navigate through the tunnels to the lower portion. Some blocks are beam destructible, others are crumbling.',
        'In that same room, go for the top instead of the bottom.',
        'Go directly right of the map room.',
        'Go past the save room beyond that missile, and go up to the second door. Cross to the fifth pipe, and bomb it. Below that, bomb the next pit, and shoot the bottom right wall.',
        'In the same room on the way to Super Missile 6.',
        'Located left of that missile. Go further left for Super Missile 7.',
        'Above Super Missile 7, jump up into the top right to find a hidden tunnel in the ceiling. Shoot the floating block.',
        'Left of the above missile, cross to the left side of the tunnels, shoot the breakable blocks, and climb to the top.',
        'In that same room, grab the ledge left of the above missile until the block reforms below you. Shoot down and right from here, and quickly cross over to that corner to find the next tank.',
        'In the shaft on the right again, climb to the very top, through the false ceiling. In the room to the left, left of the pipe, freeze some enemies to form stepping stone up to the top.',
        'Almost impossible without the Space Jump. From the incredibly long corridor at the bottom, head for the right half and make your way into the roof. Charge up a Shinespark heading right, and use the slope in the Save Room to maintain it. In the shaft at the end, jump up to the door then Shinespark right. In the last room, Shinespark up at the end and use the Space Jump to get around this room to the left edge.',
        'In the previous missile room, charge a Speed Boost heading left. Shinespark up in the corridor after that in the gap in the ceiling. From here to the right, charge up a Speed Boost and shoot your beam weapon to get rid of the block in the way and jump in an arc into the wall without hitting the edifice in the ground.',
        'In the hallway to the right of Mother Brain (after returning here a second time), charge up a Speed Boost and Shinespark all the way through Mother Brain\'s room.',
        'In the massive shaft right of the Chozo Warrior room, drop down into the first alcove on the left and use a missile on the top right block.'
      ];
      List<String> lEZM = [
        'Located right of the Morph Ball in the ceiling. Requires either skill with bomb jumping, or the Space Jump.',
        'Located atop a pillar near where you can encounter the Centipede Deorem a second time if you failed to kill it the first time.',
        'Hidden in the acid right of the Varia Suit upgrade. Blow out the floors at the bottom to reveal a tunnel.',
        'After the Wave Beam, head right again. In the room with the two centipedes, defeat them, and then find this in the ceiling above a carcass.',
        'Located in the top right next to the Zip Line charging station. Turn in on, then use the Zip Line to get to it.',
        'Located past the middle right door in the elevator shaft. Requires the Speed Booster first.',
        'Left of the elevator shaft, you\'ll see this sitting in plain sight. Don\'t walk up to it though, lest you fall down, instead jump over to it from four blocks left of the door.',
        'Located beyond Unknown Item #3, behind an Unknown Item block.',
        'Right of Ridley\'s boss room, you\'ll come across a room with pipes. Blow up the corners on either side of the central elevated area to reveal a tunnel.',
        'Stand next to the wall right before Mecha Ridley\'s room, and run left through the door. Pass through the floor using the Speed Booster. Either Shinespark or Space Jump over to the right without touching the alarm beams.',
        'Near Super Missiles 14 and 15, there is a long ramp. Run to the right to activate the Speed Booster, and Shinespark up in the center of the tall room you came down from.',
        'This Energy Tank is incredibly difficult to get. Essentially, from the Chozo Warrior room, go through the underwater area up to the top right. Blow up the missile block shortcut around the Screw Attack blocks, then go back underwater. Charge up the Speed Booster and abuse slopes to transition from aerial Shinesparks to running and press down to store the charge again. Use this to get a Shinespark to the ledge on the right side of the tall shaft and Shinespark right.'
      ];
      List<String> lSZM = [
        'In the same room as missile 5, but requires Shinesparking to get to. In the room where you acquired missiles and first encountered the Centipede Deorem, activate the Speed Booster running left. Go through the door, store a Shinespark, run back through the door and down the slope, open the door, and activate morph ball. Press A and hold left.',
        'Exit from Chozodia to Crateria via the upper door by Speed Boosting to it and storing a Shinespark before leaving. Space Jump up above to the wall above this door, then Shinespark through the wall.',
        'In the tunnel above the Hi-Jump Boots area, where missile 21 resides, go further left. In this last room, jump up and bomb the end of the platform. Let the blocks vanish, and jump over to the Super Missile before you fall through.',
        'Go right of the Map Room until you reach the dead end. Shoot through the floor and go left. Either use the Space Jump or Ice Beam to create platforms to get up to the platform in the center.',
        'Usually the first Super Missile you find, defeat the wasp Imago to get this safely.',
        'From the eastern shaft, take the middle-upper left door and pass through the first chamber. In the next room, bomb the floor to find your way up, then bomb the upper left alcove. Bomb the right wall above that.',
        'Left of that room, freeze a blue creature to create a platform, and grab the missile tank, then jump to the left and go through the door.',
        'After reclaiming your suit, drop down and go left, but blow out the missile blocks just before the door. Activate the Speed Booster going right.',
        'From the shaft to the right of the Chozo Warrior room, drop all the way to the bottom, and use the Screw Attack to the left. In the lava room, descend to the lower right and roll into the tunnel in the corner.',
        'From that same room, leave through the left side, drop down, and go left. In the next room to the right, just 3 blocks off the bottom, use a missile to open the wall.',
        'From the central save room of the Mothership, go right and up with bombs and the Screw Attack. Push the maintenance droid out of the way with missiles.',
        'From that room, take the highest left door and go up. Plant a bomb, and then defeat the Space Pirates below and jump back up.',
        'Go right of the map room in the Mothership and shoot the damaged block in the ceiling.',
        'In the glass tube connecting the ruins and Mothership, plant a Power Bomb. Drop to the bottom left, and plant another Power Bomb. Go down, and go left 3 rooms. Ascend the maze above to find this Super Missile at the top.',
        'In the room just to the left of the above, place a Power Bomb to reveal a large number of bomb blocks. Make your way through this maze as well.',
      ];
      List<String> lPZM = [
        'Activate the Speed Booster from either the left or right of the ship, and Shinespark from the edifice to the right aiming up-left. Plant a Power Bomb once you\'re up there.',
        'Once you get the Gravity Suit, go back to the map room in Norfair. Drop all the way down, into the lava, and go into the left lava-filled chamber. Shoot missiles in the left indent, go into the next room, and climb up.',
        'Located below Mother Brain\'s remains. Return here and use a Super Missile on the floor.',
        'In the Mother Ship, head for the Bridge. In the bottom left corner, drop down and into the next room.',
        'Go into the room to the right of that and plant a Power Bomb to reveal a fake ceiling, and climb up.',
        'Located on the outer edge of the Mothership, near where you spawned after defeating the Mother Brain. Climb up and plant a Power Bomb.',
        'Head to the glass tube that connects the ruins and the ship. Plant a Power Bomb. Go down and right, plant another in the corner, then run right and Shinespark up. (or Space Jump)',
        'Enter Chozodia via the top right door in Crateria (with the beak around it). When you drop down, shoot a missile at the wall to open it up. (Use the Wave Beam to find the right height).',
        'In the tall shaft between Chozodia and the Mother Ship, leading up toward the Chozo Warrior\'s Room, look along the left for a small blocked opening. Plant a Power Bomb and go inside. Go up to the highest tunnel in this room, and shoot missiles at the roof at the end.',
      ];
      List<String> lOTGZM = [
        'Located to the left of the start of the game.',
        'The first Chozo Statue will guide you to this.',
        'Acquired after defeating the Centipede.',
        'The second Chozo Statue will guide you to this.',
        'Located in Crateria, start from the Norfair elevator and go right. In this room, go to the top left, and navigate the tunnels to the end in the Chozo Ruins area.',
        'From the Unknown Item above, ascend into the open air area above back the way you came. Climb to the top left, drop down, and go left.',
        'From the main elevator in Norfair between it and Brinstar, go right. At the shaft at the end, go up and take the first door on the left. The Power Grip is incredibly important but not quite necessary to get through.',
        'Located at the bottom left of Kraid\'s Lair, accessible via a winding path from the bottom left door from the elevator room. The path is left, down, right, down, right through the wall, down through the floor, left, down, then right.',
        'Located behind Kraid after defeating him.',
        'After getting the Speed Booster, return to Norfair. From the elevator, run straight right and don\'t stop until you hit a wall. Go down, go through the door, turn around and do the same thing. Drop down again, then go through the door on the left.',
        'The Hi-Jump boots are suggested, though not necessary for this. At the very top of the brown main shaft in Brinstar, go right. Get through this room, and just before the Save Room, shoot up. Jump over and up and get through the next room.',
        'A Chozo Statue will guide you here, but the Wave Beam is in Norfair buried deep in the center. From the Hi-Jump, head left until you reach a shaft. Go down, through the floor, and through the door on the right. Just before the Save Room, shoot the floors.',
        'The first time in Ridley\'s room, he won\'t show up. Pass it and go left.',
        'After beating Ridley, go right at the elevator through the now-collapsed wall. Below the next room is a long tunnel going left. Keep shooting to destroy the walls and Speed Boost to the end. Drop into the revealed Morph Ball Launcher, then go left at the top.'
      ];
      for (int i = 1; i <= 50; i++) {
        Hive.box('ZeroMission').put(
            "Missiles $i",
            Item(
                itemType: "Missiles $i",
                itemId: i,
                location: lMZM[i - 1],
                checked: false));
        if (i <= 15) {
          Hive.box('ZeroMission').put(
              "Super Missiles $i",
              Item(
                  itemType: "Super Missiles $i",
                  itemId: i,
                  location: lSZM[i - 1],
                  checked: false));
          if (i <= 12) {
            Hive.box('ZeroMission').put(
                "Energy Tank $i",
                Item(
                    itemType: "Energy Tank $i",
                    itemId: i,
                    location: lEZM[i - 1],
                    checked: false));
            if (i <= 9) {
              Hive.box('ZeroMission').put(
                  "Power Bombs $i",
                  Item(
                      itemType: "Power Bombs $i",
                      itemId: i,
                      location: lPZM[i - 1],
                      checked: false));
            }
          }
        }
      }
      Hive.box('ZeroMission').put(
          'Morph Ball',
          Item(
              itemType: 'Morph Ball',
              itemId: 1,
              location: lOTGZM[0],
              checked: false));
      Hive.box('ZeroMission').put(
          'Long Beam',
          Item(
              itemType: 'Long Beam',
              itemId: 1,
              location: lOTGZM[1],
              checked: false));
      Hive.box('ZeroMission').put(
          'Charge Beam',
          Item(
              itemType: 'Charge Beam',
              itemId: 1,
              location: lOTGZM[2],
              checked: false));
      Hive.box('ZeroMission').put(
          'Bombs',
          Item(
              itemType: 'Bombs',
              itemId: 1,
              location: lOTGZM[3],
              checked: false));
      Hive.box('ZeroMission').put(
          'Unknown Item #1 (Plasma Beam)',
          Item(
              itemType: 'Unknown Item #1 (Plasma Beam)',
              itemId: 1,
              location: lOTGZM[4],
              checked: false));
      Hive.box('ZeroMission').put(
          'Power Grip',
          Item(
              itemType: 'Power Grip',
              itemId: 1,
              location: lOTGZM[5],
              checked: false));
      Hive.box('ZeroMission').put(
          'Ice Beam',
          Item(
              itemType: 'Ice Beam',
              itemId: 1,
              location: lOTGZM[6],
              checked: false));
      Hive.box('ZeroMission').put(
          'Unknown Item #2 (Space Jump)',
          Item(
              itemType: 'Unknown Item #2 (Space Jump)',
              itemId: 1,
              location: lOTGZM[7],
              checked: false));
      Hive.box('ZeroMission').put(
          'Speed Booster',
          Item(
              itemType: 'Speed Booster',
              itemId: 1,
              location: lOTGZM[8],
              checked: false));
      Hive.box('ZeroMission').put(
          'Hi-Jump Boots',
          Item(
              itemType: 'Hi-Jump Boots',
              itemId: 1,
              location: lOTGZM[9],
              checked: false));
      Hive.box('ZeroMission').put(
          'Varia Suit',
          Item(
              itemType: 'Varia Suit',
              itemId: 1,
              location: lOTGZM[10],
              checked: false));
      Hive.box('ZeroMission').put(
          'Wave Beam',
          Item(
              itemType: 'Wave Beam',
              itemId: 1,
              location: lOTGZM[11],
              checked: false));
      Hive.box('ZeroMission').put(
          'Unknown Item #3 (Gravity Suit)',
          Item(
              itemType: 'Unknown Item #3 (Gravity Suit)',
              itemId: 1,
              location: lOTGZM[12],
              checked: false));
      Hive.box('ZeroMission').put(
          'Screw Attack',
          Item(
              itemType: 'Screw Attack',
              itemId: 1,
              location: lOTGZM[13],
              checked: false));
    }
    if (Hive.box('OtherM').isEmpty) {
      List<String> lMOM = [
        'After defeating Brug Mass, exit the chamber and in the next corridor go through the weakened grate in the floor and follow the tunnel.',
        'Travel to the chamber with restrooms a distance from the hangar. Climb up the stairs, and walk into the windowed enclosure. Shoot a missile at the air vent on the wall and roll inside.',
        'With bombs, backtrack to where you encountered the 7th Platoon. Climb on top of the stacked crates and look for a nearby platform at the rear of the chamber on the left wall. Jump over and lay a bomb beside the vent.',
        'In the large chamber where you were ambushed by a swarm of Reo, jump to the base of the room and look for a weakened grate in the floor. Use a bomb here.',
        'On the way back to the command room from the System Management Room, you\'ll end up in a chamber with a bridge that retracts and you\'ll be ambused by three Sidehoppers. At the southern end of this chamber, use a walljump.',
        'After restoring power, return south of the command room to the elevator. Ride it up to the top and use the terminal. Down below the left side, there is a small opening in the wall on top one of the platforms.',
        'After receiving direction towards Sector 1, exit the command room to the east and take the elevator up one floor. In the following chamber, shoot open the third large vent in the ceiling to destroy a Reo nest, and wall jump up.',
        'From that missile, move forward to the next chamber, but don\'t go into the elevator just yet. Go into the vent on the left side and bomb the grate.',
        'Requires the Speed Booster. Travel to the corridor connected to the System Management Room and go south. In the ruined elevator shaft, go to the bottom and further south, then turn around and Shinespark back up the elevator shaft. Destroy the crate.',
        'After the first Griptian encounter (armadillo-like creature) go towards the Super Missile blast shield. Jump up to the grate in the wall and go in.',
        'Located in the first hologram chamber, after encountering the little bird-like creature. Switch off the hologram chamber and backtrack, and it will be on top of a metal structure off one side.',
        'Just beyond the desert containing Dragotix is a corridor filled with Geemers. Look closely and you\'ll notice a group of pests blocking part of the ground. Clear them out.',
        'After surviving the elevator Ghalmanian encounter, ascend to the top of the shaft and look for a tunnel across from the exit.',
        'Soon after the above missile, you\'ll be in a blue and green lit room with a small Super Missile blast shield on the left wall. Look at the opposite wall for an opening.',
        'In the observation room overlooking Dragotix, find a small tunnel near the window. Be careful to jump over a hole near the bottom so you don\'t fall through.',
        'Continuing from the above tunnels, you will end up in the Scrap Block. Defeat the Wavers, then use a missile left of the exit to reveal a tunnel.',
        'In the Biological Experiment Floor, climb to the top of the spiral path around the Kihunter hive. You\'ll pass the platform holding the missile, jump from above to get it.',
        'From the Navigation Room following the King Kihunter, go through the door at the bend in the L-shaped corridor. In the next room, use the terminal to retract the bridge, and drop below. Go back instead of forward, and use first-person mode to find a hidden tunnel.',
        'In a later corridor after that one, you\'ll find a submerged room, and defeat the Whipvine on the wall hidden in the water with a Missile. Climb into the pipe.',
        'In the room where the water level can be raised and lowered, travel to the far end and look for a hidden tunnel underwater.',
        'Past the navigation room after the first Groganch encounter, you\'ll reach an elevator. In the antechamber preceding it, look up to the ceiling and shoot the suspended crate with a Missile.',
        'Requires the Grapple Beam. From the arbor chamber with the giant tree, move north to a room with a cliff obstructing the path. Look up and use the Grapple Point. Look for a small tunnel on the right side of the cliff and use a bomb to get in.',
        'Requires the Grapple Beam*. In the large circular chamber surrounded by glass and foliage beyond, you may see a Grapple Point beyond a window. Pull yourself to it, and destroy a nearby crate. \n*: Possibly not available until late game after the Griptians inhabit the area.',
        'Requires the Speed Booster. Near the entrance of the wrecked pipe that leads to the Subterranean Control Room is a dirt tunnel, as well as a tall shaft leading up. Run down the dirt tunnel towards the shaft and Shinespark up. Break the crate on the right.', //sector 1-15
        'Requires Space Jump and Super Missiles. Travel beyond the northwestern Navigation room to a room that contains a hologram generator. Deactivate it to reveal a Super Missile door on the east wall. Fire the missile from the generator and Space Jump over.',
        'Requires the Speed Booster. Travel to the bottom of the elevator shaft that you crushed a Ghalmanian in. Outside the door is a chamber of Geemers. You need to Shinespark through the hole in the ceiling that light is pouring through. Use the nearby long chamber to charge a Shinespark. Drop back down and keep an eye open for an opening on the left.',
        'Requires Super Missiles. Just outside the top of the elevator shaft in the previous missile was Missile 14. Find the Super Missile hatch nearby that room.',
        'Requires the Speed Booster and Super Missiles. Travel to the Breeding Room, and open the Super Missile door you previously skipped. Open the door, run back to the left end, and Speed Boost through the door. Assuming no loading screen shows up, immediately in that room Shinespark up.',
        'Later in the game, a hatch two doors down from the Breeding Room will be unlocked. Go inside and walljump.',
        'Requires the Speed Booster, Grapple Beam, and Super Missiles. Move into the jungle outside the Breeding Room near where you first entered this area. There is a tall slippery slope in this room, use the Speed Booster to get up. There\'s a Super Missile hatch on the ceiling that you can only hit while sliding down the slope, so charge and aim while sliding to hit it. Speed Boost back up the slope, and grab the Grapple Point that is revealed.',
        'Requires the Speed Booster. In the room with the huge tree, Speed Boost up to the end of the spiral going around it, and Shinespark up at the dead end.',
        'Requires the Gravity Suit and Speed Booster. In the same watery room as Missile 19, at the end of the corridor, is a grate. Activate the Speed Booster running into the grate (and shoot the enemies that get in the way).',
        'Requires the Space Jump. Just beyond the Navigation Room next to the rainy area where you fought the first Groganch, is an L-shaped corridor containing Kihunters and Zeros. Turn the corner, look up, and Space Jump up to the alcove',
        'Requires the Wave Beam. In the observation room just past the above missile tank, exit the room through the right door and walk through the next corridor looking past the glass in the background. When you see the Charge Beam switch in the background, shoot it and enter the opened room and go to the end.',
        'Requires the Speed Booster. In the large curving jungle region leading up to the outdoor Biosphere Test Area, climb onto the metal walkway along the left. Speed Boost along this walkway through the dirt wall at the end.',
        'Outside the first Navigation room lies an L-shaped corridor. Around the corner is a Himella nest with a fallen stalactite. Use first-person mode to look for an entry and roll in with the Morph Ball.',
        'In the room where you find the first Fumbleye, drop into the water and go right.',
        'After defeating the first Kyratian, notice the stream to the right of the exit. Roll inside.',
        'Shortly after, you\'ll find yourself inside again between two outdoor areas. Clear out the enemies and look for the opening of a pipe with a soft red glow. Roll through to the ceiling.',
        'Adjacent to that room, you\'ll be in another area with 2 Kyratians and several stalactites. Defeat them, cross the cavern, and look for a hidden tunnel below the surface of the second lake.',
        'In a later chamber, you\'ll encounter a frozen Gigafraug corpse. Look behind it at the exhaust fans, and use the charged Ice Beam to freeze the center one and crawl past.',
        'In the Water Tank chamber, defeat 2 more Kyratians, then climb up the right and walk towards the corner. Look for a hole in the ceiling to jump up.',
        'In the corridor where the Speed Booster gets authorized, return to the entrance, then activate the Speed Booster towards the slope. At the top when it flattens out, hold 2, then hold down, then release 2 to shinespark back to an alcove.',
        'In the Sector Generator Room, go to the second rotating cylinder on the right and climb up to the top. Hang from the edge, and wait until the platform brings Samus close to the screen, and hop onto the catwalk and follow it.',
        'In the room where you are authorized to use the Wave Beam, walk behind the colored crates in the corner.',
        'In one of the following rooms, where you are required to Shinespark to proceed, defeat the Volfons and run down to the cliff ahead, then run back to charge the Shinespark. When you pass the blue dot on the map, Shinespark up, and hold forward to fall on to it. Alternatively, after the avalanche, return here and use the Grapple Point to get up.',
        'Requires Super Missiles. Go to the corridor between the main elevator and the Navigation room. Open the Super Missile hatch there.',
        'In the southern region where you encountered a Gigafraug and a Himella nest, there should be a stalactite above an indent in the ground. Fire a missile at it, and get to the opposite side of the room. Charge up the Speed Booster and Shinespark through the revealed hole. Jump forward as you hit the ceiling to grab the ledge instead of falling.',
        'From that missile, roll back towards the breach and Spring Ball over the gap just before reaching the edge and roll to the opposite edge to find a crate.',
        'Requires the Space Jump and Gravity Suit. In the deep southeastern regions, with the bizarre gravity, go to the multi-leveled chamber near the end. Use the Grapple Points and get to the top right. Space Jump left of there into the wall, and wall jump even further above that.',
        'In the same region, go to the beginning of this area to the blue room with red lights on the platforms. On the left wall is a tunnel entrance, which you can Space Jump to from above and grab hold of.',
        'Requires the Space Jump and Wave Beam. Travel to the large chamber with stasis tanks housing Geemers and Himellas (and possibly a Fumbleye on the ceiling). Defeat the targets (easily with a Power Bomb) and Space Jump off the bridge into the revealed alcove.',
        'Requires Super Missiles. Go to the open-air Experiment Floor and go inside the tunnel connecting it and the Materials Storehouse. Open the Super Missile hatch on the ground near the exit.',
        'In the Materials Storehouse, as you enter from the Experiment Floor, a platform rests on the oppposite side of a glass wall. Use the Space Jump to get over from the nearby stairwell or stacked cargo crates. Climb into the tunnel in the wall.',
        'After acquirning the Ice Beam, you\'ll face some Dessgeegas in a dirt corridor of exhaust vents. Lock onto the vent that is constantly spewing flames and shoot it with the charged Ice Beam to reveal a tunnel.',
        'Go to the Floor Observation Room, and roll underneath the raised stairwell leading up to the control terminal station.',
        'Outside the Floor Observation Room is a small corridor that leads to a vista overlooking the volcano. Find the open grate along the wall and follow the tunnel.',
        'During the ascent through the Desert Refinery, you\'ll need to use the Morph Ball for a section. At the branch inside those tunnels, go right.',
        'After the boss in the Geothermal Power Plant, you\'ll be in a narrow maintenance shaft. As you descend (before the lava), watch the left side for a hidden tunnel opening. If you miss it, you can get back to this room via the bomb launcher next to the main elevator.',
        'Requires Power Bombs. Go to the chamber east of the main elevator where the Grapple Beam was authorized. Climb up to the top and open the Power Bomb hatch.',
        'Requires the Space Jump, Wave Beam, and Speed Booster. Return to the entrance to the Geothermal Power Plant and backtrack to the slope where the robots generate purple energy fields outside the windows. Defeat them with the Wave Beam, the Speed Boost to the bottom of the sloping tunnel, through the door, and Shinespark up in that room. Space Jump to the right as you start to fall.',
        'Requires Super Missiles. Past the transparent tunnel that Vorash tried to eat you in on your first visit is a darkened room with Heat Bulls in it. Open the Super Missile hatch near the bottom of the slope.',
        'Requires the Wave Beam. At the floor of that same transparent tunnel (that Vorash DIDN\'T eat...) there is a sealed hatch. Look at the rocky formation outside the window on the right and you might spot a Charge Beam switch. Hit it and drop down.',
        'Requires Power Bombs. Travel to the northeast of the magma ocean, where Magdollites now inhabit in place of Vorash. Enter first person mode, and note the lone stalagmite separate from the rest. Use a Power Bomb to destroy it.',
        'Requires the Varia Suit and Space Jump. Go to the navigation room on the southeastern side of the magma ocean. Pass through the tunnels and shafts and fall down to the bottom of the first shaft to find a lava pond. Space Jump across.',
        'Near that missile is a second tall shaft. At the top is a Super Missile hatch. Open it.',
        'Requires the Space Jump. In the long chamber containing an elevator to the top of the Desert Refinery (also containing a Dragotix,) the Missile Tank is in plain view in an alcove in the lava pit where the two Magdollites are. Leap in and Space Jump to it.',
        'Near the entrance, walk up the ramp from the main terminal into another room to see this tank in plain sight. Prepare for a fight afterwards.',
        'After the final boss encounter, return to the chamber it was in and travel through the southern door. Walk to the computer terminals on the right and target the center octagonal shape on the floor, and fire a missile or lay a bomb.',
        'Climb up the stairwell of the same room, and you\'ll see the tank behind the glass. Go behind the fourth display of the large main terminal here, climb in, and wall jump up to some tunnels. Follow them to the end.'
      ];
      List<String> lEOM = [
        'Found on the way to the System Management Room in the Main Sector, look for a damaged pipe along the ceiling. Requires bombs.',
        'After the second Groganch encounter in Sector 1, moving towards the Biosphere Test Area and Exam Center, look for an automatic platform on the left wall. Ride up and follow the tunnels.',
        'After receiving the Speed Booster, in Sector 2 go back where you fought the first Gigafraug. Move to the top of this cavern, then exit the cavern and move down the adjacent corridor. Run back, then shinespark over the edge of the broken bridge. Look for a small hole behind a pillar on the right.',
        'In northern Sector 2, continue through the upper ventilation chambers and eventually you\'ll fall right into this one.',
        'In Sector 3, inside the entrance to the Geothermal Power Plant, climb up the stairs.'
      ];
      List<String> lPOM = [
        'Near the Main Elevator is another tall elevator shaft. Go to the bottom of the elevator and climb up the shaft using the platforms. Get all the way to the top.',
        'After getting Power Bombs, go to the Bottle Ship Residential Area and climb the spire in the center of the area by shinesparking up, and then Space Jumping toward it.',
        'After defeating the King Kihunter, you\'ll enter a green corridor and see the Energy Part. Look for a grate in the wall at the top of the slope and use a bomb.',
        'Requires the Space Jump. North of the arbor chamber is a jungle region with a large cliff. Use the Grapple Beam to scale the cliff. Jump off the left side and Space Jump around the corner and break the crate you see.',
        'Requires Power Bombs. Travel to the Subterranean Control Room and look in the corner for a Power Bomb hatch.',
        'Requires Space Jump or Grapple Beam. In the area where Dragotix was, go to the northwestern corner either by following the pipes from the observation room using the Grapple Beam as needed, or alternatively climbing to the northern exit of the room and Space Jumping over.',
        'Requires the Space Jump. In the room where you fought your first Groganch (tree creature), climb up to the northwestern exit. Space Jump around the fence on the right, and shoot the Charge Beam switch and cross the platforms it reveals quickly. Alternatively, Shinespark up to this, then Space Jump.',
        'After passing through the Sector Generator Room, you\'ll come across a large room where you need to Shinespark to get across. Instead, drop to the bottom and blow up the grate in the ground closest to where you came in.',
        'In the southern region, there exists a room that contains a Himella nest, a Gigafraug, 2 missile tanks, and a Power Bomb hatch. Open the hatch.',
        'After the boss encounter in the Materials Storehouse, backtrack around Sector 2 and come in through the original entrance. Alternatively, use the Space Jump to get up there. Destroy the small cargo crates to find this one.',
        'Requires Power Bombs. Just outside of the exit of the Materials Transfer Lift, there is a chamber with another Power Bomb hatch. Open the hatch.',
        'Soon after entering this Sector, just before the Navigation Room, look for a trio of fireflies, and roll through the tunnels beside them.',
        'In the magma ocean, travel to the region in the bottom left corner of the area near the exit to the Floor Observation Room, and look for a rocky cliff. There\'s a hole in the left side, leading to a grate.',
        'On the way up to the crater, you\'ll enter a room with a glass panel on the floor where you activate a terminal and get ambushed by Cyber Zebesians. Go through the right hatch before you go down into the volcano through the left hatch.',
        'In the long lava-filled industrial chamber near the Blast Furnance Observation, you\'ll find two Grapple Points. You won\'t be able to proceed here without the Grapple Beam, but once you have it, cross over and walk towards the screen to drop down into a secondary tunnel.',
        'Requires Grapple Beam and Super Missiles. In the chamber to the right of the main Sector 3 Elevator, where you fought an Asborean and Rhedogian. In this room, climb to the upper floor and open the Super Missile hatch. Activate the terminal, and use both Grapple Points.'
      ];
      List<String> lAOM = [
        'Requires the Wave Beam. In the Main Sector, head to the elevator south of the command room, next to the navigation room. In here, look for a switch through the window and stand close enough to make it turn green. Shoot it with the Wave Beam to open an alcove containing the item.',
        'In Sector 1, you\'ll find a tunnel overlooking a jungle environment containing two Groganches. Move through this area into a lounge-like area, and in the adjacent restrooms, go to the last cubicle in the women\'s restroom.',
        'In Sector 2, where you battle a Groganch and cause an avalanche, climb up and around the bend, aim and fire a missile at a rock formation atop a slope.',
        'In Sector 3, in the room where the Ice Beam is authorized and 4 Cyborg Zebesians reside, shoot the round pod near the Mella nest with a missile and roll into the bomb launcher.',
        'In the entrance room to the Geothermal Power Plant, climb up the stairs. Stand against the guard rail and use first person mode to look for a grapple point. Swing across to the blue-lit alcove.',
        'In the entrance to Sector 3 from Sector 1, which is now sealed, plant a Power Bomb in front of the hatch.'
      ];
      List<String> lROM = [
        'In Sector 1, in the chamber just inside the Biosphere Test Area, plant a Power Bomb in front of the hatch just next to the now-locked door.',
        'In Sector 2, immediately after getting the Speed Booster authorization, run straight through the icy obstructions in the way, all the way up the slope and into a cave.',
        'Requires the Gravity Suit. In Sector 2, in the southeastern region with increased/reversed gravity, there is an L-shaped chamber with 2 Kyratians. Defeat them, and ahead in an alcove, you\'ll see the E-Recovery Tank.'
      ];
      List<String> lOTGOM = [
        'Made available during Brug Mass.',
        'Made available after Brug Mass.',
        'Found past the Subterranean Control Room in an area with 3 FG-1000s.',
        'Made available after escaping Vorash.',
        'Made available later in Sector 3.',
        'Made available in Sector 2 when needed.',
        'Made available in Sector 2 when needed.',
        'Made available in Sector 3 when needed.',
        'Made available during an encounter late in Sector 3.',
        'Made available during the boss of Sector 3.',
        'Made available in Sector 1 when needed.',
        'Found in Sector 1 upon defeating the Rhedogian.',
        'Made available when needed in Sector 2.',
        'Made available when needed very late in the game.'
      ];
      for (int i = 1; i <= 70; i++) {
        Hive.box("OtherM").put(
            "Missile Tank $i",
            Item(
                itemType: "Missile Tank $i",
                itemId: i,
                location: lMOM[i - 1],
                checked: false));
        if (i <= 16) {
          Hive.box("OtherM").put(
              "Energy Part $i",
              Item(
                  itemType: "Energy Part $i",
                  itemId: i,
                  location: lPOM[i - 1],
                  checked: false));
          if (i <= 6) {
            Hive.box("OtherM").put(
                "Accel Charge $i",
                Item(
                    itemType: "Accel Charge $i",
                    itemId: i,
                    location: lAOM[i - 1],
                    checked: false));
            if (i <= 5) {
              Hive.box("OtherM").put(
                  "Energy Tank $i",
                  Item(
                      itemType: "Energy Tank $i",
                      itemId: i,
                      location: lEOM[i - 1],
                      checked: false));
              if (i <= 3) {
                Hive.box("OtherM").put(
                    "E-Recovery Tank $i",
                    Item(
                        itemType: "E-Recovery Tank $i",
                        itemId: i,
                        location: lROM[i - 1],
                        checked: false));
              }
            }
          }
        }
      }
      Hive.box('OtherM').put(
          'Missile Launcher',
          Item(
              itemType: 'Missile Launcher',
              itemId: 1,
              location: lOTGOM[0],
              checked: false));
      Hive.box('OtherM').put(
          'Morph Ball Bomb',
          Item(
              itemType: 'Morph Ball Bomb',
              itemId: 1,
              location: lOTGOM[1],
              checked: false));
      Hive.box('OtherM').put(
          'Diffusion Beam',
          Item(
              itemType: 'Diffusion Beam',
              itemId: 1,
              location: lOTGOM[2],
              checked: false));
      Hive.box('OtherM').put(
          'Ice Beam',
          Item(
              itemType: 'Ice Beam',
              itemId: 1,
              location: lOTGOM[3],
              checked: false));
      Hive.box('OtherM').put(
          'Varia Suit',
          Item(
              itemType: 'Varia Suit',
              itemId: 1,
              location: lOTGOM[4],
              checked: false));
      Hive.box('OtherM').put(
          'Speed Booster',
          Item(
              itemType: 'Speed Booster',
              itemId: 1,
              location: lOTGOM[5],
              checked: false));
      Hive.box('OtherM').put(
          'Wave Beam',
          Item(
              itemType: 'Wave Beam',
              itemId: 1,
              location: lOTGOM[6],
              checked: false));
      Hive.box('OtherM').put(
          'Grapple Beam',
          Item(
              itemType: 'Grapple Beam',
              itemId: 1,
              location: lOTGOM[7],
              checked: false));
      Hive.box('OtherM').put(
          'Super Missile',
          Item(
              itemType: 'Super Missile',
              itemId: 1,
              location: lOTGOM[8],
              checked: false));
      Hive.box('OtherM').put(
          'Plasma Beam',
          Item(
              itemType: 'Plasma Beam',
              itemId: 1,
              location: lOTGOM[9],
              checked: false));
      Hive.box('OtherM').put(
          'Space Jump/Screw Attack',
          Item(
              itemType: 'Space Jump/Screw Attack',
              itemId: 1,
              location: lOTGOM[10],
              checked: false));
      Hive.box('OtherM').put(
          'Seeker Missile',
          Item(
              itemType: 'Seeker Missile',
              itemId: 1,
              location: lOTGOM[11],
              checked: false));
      Hive.box('OtherM').put(
          'Gravity Suit',
          Item(
              itemType: 'Gravity Suit',
              itemId: 1,
              location: lOTGOM[12],
              checked: false));
      Hive.box('OtherM').put(
          'Power Bomb',
          Item(
              itemType: 'Power Bomb',
              itemId: 1,
              location: lOTGOM[13],
              checked: false));
    }
    if (Hive.box('SamusReturns').isEmpty) {
      List<String> lMSR = [
        'After getting the Morph Ball, go back a room and defeat the enemy blocking the hole on the left.',
        'After grabbing the Scan Pulse, use it to reveal a breakable wall on the left side. At the bottom, break the debris on the left and continue up to the top and go right in Morph Ball form.',
        'As you go down, go left at the fork, but before you get to the Energy Refill station, crouch, look right, and fire a missile.',
        'Before the second Save Station, use a Scan Pulse and break the revealed blocks to the left.',
        'Above the room contiaining the Charge Beam is a small area containing the missile expansion. From the shaft, shoot the small weak point on the right.',
        'Obtainable after Area 1. Blow up the bomb block left of the Teleport station. Blow up the next bomb block, and Spider Ball up the shaft.',
        'Obtainable after Area 1. Drop down right of the Teleport station and go right. Use the Spider Ball to climb up.',
        'Obtainable at the end of the game. On your way back up from Area 8 to the surface, let the Baby Metroid destroy the crystal blocks in the middle top of the long hall. Freeze an enemy to get close enough to do it.',
        'In the room where you get the Bombs, place one on the floor just before the ramp. In that tunnel, use bomb jumps to climb around.',
        'Leave the Teleport station going left. Drop through the floor, and go through the door on the right. On the right side of this room, jump up to the ledge and go crawl into the hole. Use a bomb at the end.',
        'Go to the Save Station near the Spider Ball room. Use the Spider Ball to go up the right side.',
        'In the big open cave at the top of the area, use the Spider Ball to get to the ceiling, and break through the weak block left of the Missile Recharge station. Destroy the blocks below the vent, and fire a missile up at the weak spot below the expansion.',
        'Get on top of the highest area in that same room. Go underneath the long platform on the left, and bomb the center.',
        'This one is visible in a room on the lower portion of the area, but the bomb block can\'t be opened because of a vent. Go around to the room on the right, and bomb the top left corner to find a different entrance.',
        'Obtainable after Area 6. Return to the lava room in this area and cling to the ceiling to cross the area.',
        'Obtainable after Area 6. Just after the elevator to Area 2 is a passageway right. Hang from the left ledge and shoot a missile at the weak block. Head inside, and jump up to the high ledge, and open the door with the Wave Beam. Use the Spring Ball to plant a bomb along the wall.',
        'Obtainable after Area 4. In the top of the area is a door with a purple 3-eyed creature on it. Use the Spazer Beam to destroy it, and go inside but don\'t drop down. Use the Spider Ball across the ceiling.',
        'Just before the room with the first Metroid of the area, destroy the weak spot in the right wall.',
        'Use the new Lightning Armor to run through the hall of red flora beyond the left path above.',
        'Leave the room containing the Lightning Armor and look for three weak spots in the wall on the right. Use bombs, and roll through the pond of water. Activate the lightning armor in the poisonous gas and roll under. Bomb the weak spots and drop into the water.',
        'After using the first elevator in this area, use the Spider Ball to get over to the passageway on the left wall. Climb up and bomb the weak wall and move through.',
        'After getting the Varia Suit, enter the lava room, and blow up the walls above the lone fire-breathing creature.',
        'In the room with the High Jump Boots, bomb the floor in front of the ramp and go left. Use a missile on the weak block above, and jump up and roll into the next room.',
        'In one of the lower sections of Area 2 is a room containing a Save station and Missile Recharge station. Break the weak spot in the wall above the Missile Recharge with a bomb, then roll right, go up, bomb at the end, and go left.',
        'Underneath the Chozo Seal to Area 3 is a passage of poisonous flora. Use the Lightning Armor and Spider Ball to break through and climb up.',
        'Obtainable after Area 3. Go to the lava area where the Teleport station is, and use the Burst Beam on the egg above, and bomb the weak block.',
        'Obtainable after Area 4. In the top right corner of the map is an expansion on a ledge inaccessible by Spider Ball. Use the Space Jump to get up here.',
        'As you fall through the tall shaft on the right side, watch the right side for a spot where the wall and floor form a ceiling corner, and bomb it.',
        'From the left elevator, go down, take the first right, and kill the gamma, use the Grapple Beam to open the red glowing orb beyond the tunnel, pass through and go down. Break a weak block left of the water.',
        'In the center shaft of the three tall shafts in the bottom portion, climb up to the top above the Teleporter station using the Grapple Beam and Spider Ball. Destroy the eggs with the Burst Beam.',
        'At the top of the left shaft beyond that, go right through a passage way, and at the end, fire a Missile then the Grapple Beam into the sticky shaft. Climb up and roll through.',
        'In the same shaft as the left elevator, go down below the Gamma room and destroy the top right corner of the first platform there. ',
        'After killing the Alpha left of the left elevator of the main area, enter the door on the left, ride that elevator, and use the Grapple Beam on the red orb.',
        'After draining the purple liquid leading into area 4, go through the first door on the left. Roll into the passageway left of the red block, and pull the red block to reveal the path to the expansion.',
        'From the same room, drop below the passageway and take the lower door. Bomb the passageway in the ceiling, and use the Lightning Armor to move past the enemy. Break the red block, then follow the revealed passageway.',
        'Obtainable after Area 4. Go to the large open room at the top, and Space Jump into the top left corner.',
        'Obtainable after Area 5. In the lower area of the leftmost of the 3 bottom shafts is a submerged area. With the Gravity Suit, roll through and shoot two Missiles up at the dead end.',
        'Obtainable after Area 5. Go to the Aeion Recharge on the rightmost side of Area 3, and Space Jump up to the top, and Screw Attack through the blocks in the middle. Let it reform, land, and shoot the wall 4 blocks up with a missile.',
        'In the room with poisonous flora on the left side of the map, freeze an enemy to form a platform. Jump up towards the C-shaped alcove, and fire a missile into the hole.',
        'Directly below the room with the first Gamma Metroid of the area is a room with a weak block on the left wall. Destroy that, then fire a missile through the hole and roll through quickly.',
        'After activating the first Chozo Seal in the first room of the area, go to the Teleport station room and take the right exit. Spider Ball over the flora, and bomb the ceiling.',
        'Located left of the Energy Recharge found during the second chase. Run underneath its location and find a weak spot on the left wall. Bomb your way in, then bomb your way up the pillar that you find by destroying a block, Spider Balling to the top of the next, and dropping down when the block below reforms.',
        'In the room with the third section of the chase, underneath a rock. Bomb above it to get to it.',
        'Just before the Zeta Metroid in the top center room, Space Jump to the top of the shaft leading down to it, and find the ledge in the top left corner.',
        'Near the start of Area 4 is a place where you can Space Jump up to a purple door. Go through it.',
        'Right before the last metroid of the area, you\'ll end up in a ceiling passage with some small platforms. Stick to the ceiling as you move through here to not fall through and go to the left end.',
        'Obtainable after Area 5. Above the top right energy recharge station is a door leading into a lava area. With the Gravity Suit, dive through the lava and Space Jump out of the other side.',
        'Obtainable after Area 8. In the area with the first Diggernaut chase, there is a small passage with blue crystals within. Use the baby metroid to destroy them.',
        'At the start of the area, look for a weak spot right of the Teleporter here. Follow the passage.',
        'A few rooms above the Plasma Beam, there is a room with an elevator on the left. At the top right, go through the passage. Use the Phase Drift in this area to cross two gaps, but once you reach the impassable Power Bomb door, drop and cling to the right side of the pit.',
        'After getting the Gravity Suit, make your way out of the water, but before you make it out, look in the bottom right corner for a passageway with a weak block. In this room, Grapple Beam past the red spikes. Roll up and around, and use the Phase Drift to be safe.',
        'In the large external area, above the left side Save station, use the Screw Attack to break through and get to the right side above the spikes.',
        'In the top left corner of that same room is a hidden weak block. Blow it up and roll in.',
        'Just before the Gamma Metroid on the right side of the main area in the room with the river in the background, is another room with some water at the bottom. On the right wall, blow up some blocks and roll in. Use the Burst Beam on the eggs and pass through the tunnels.',
        'In the spiky room preceding the Zeta Metroid, go to the top. Fire a missile past the diagonal red spikes, and use the Phase Drift above them to roll around.',
        'Screw Attack in hand, return to the room just right of the Plasma Beam room. Pull the right side red block, drop down and use the Screw Attack to break the blocks. Spider Ball back up to this platform, and use the Phase Drift to get to the right side and plant a bomb.',
        'On your way to the leftmost Metroid, drop down to the bottom after passing all the poisonous flora. Bomb the right wall and roll through.',
        'Return to the room just before where you fought the first Alpha Metroid of the area, and in the bottom right corner of the water, roll into a passageway and jump up.',
        'Obtainable after Area 8. In the room above the Plasma Beam, with the Teleporter, break the crystals.',
        'From the Omega at the top of the area, go left into the next room, and bomb the floor left of the Aeion recharge. Drop through and use the Lightning Armor.',
        'In the top right of the area, right of the Zeta Metroid room, use the Phase Drift to cross the weak blocks, and bomb the left side.',
        'After draining the lower portion of Area 6, go left of the Save station connecting the two halves by bombing the wall. Activate Phase Drift inside.',
        'Once you get to the Ammo Recharge, Spider Ball to the ceiling and bomb the weak spot.',
        'In the room with two sets of crumbling floors, activate Phase Drift across the weak floor. At the wall, place a bomb and Spider Ball up. Go back down after the explosion.',
        'In the first room, shoot a missile right of the Aeion Recharge at the top.',
        'After defeating the Omega Metroid at the top left, go back a room and get into the passageways along the top using a Power Bomb.',
        'Get to the top of the shaft at the top right, and use the grapple beam to pull yourself past the red spikes.',
        'In the room below the central Omega Metroid, there is a missile visible behind some more red spikes. Go to the left side of the room, and get into the small hole along the wall using the Spider Ball. Plant a Power Bomb to launch yourself through the spikes.',
        'Left of the rightmost Omega Metroid, there is an Aeion Recharge. Below that, and to the right, fire a missile into a weak block to reveal the expansion.',
        'After draining the liquid at the bottom left, drop down and go to the door. Plant a Power Bomb next to it and Phase Drift in the revealed passage.',
        'Obtainable after Area 8. Break the blue crystals in the bottom left of the first room of Area 7.',
        'A few rooms into the area, you\'ll end up in a large room before the main room of Area 8. Drop through the 2 crumbling blocks here, and Screw Attack into the right wall below.',
        'On the left side of that room, use the Screw Attack to break through the floor. Safely cross to the right side of this tunnel.',
        'Space Jump up the left wall of the main room.',
        'Go left of the Ammo Recharge in the main room, and stand in the left corner. Start a Screw Attack without moving to safely avoid the crystals. Grab the ledge, and Spider Ball to the ceiling, then drop to the right where the weak spot is hidden.',
        'As you climb up, you\'ll spy an expansion blocked off in some tunnels. Destroy the Grapple Block from the left, then enter from the right to get it.',
        'After killing the last 3 metroids in the left shaft, blast the weak point on the left to reveal a missile expansion.',
        'Climb up the chamber behind the Queen Metroid, and use the Lightning Armor to roll right through the poisonous flora.',
        'Obtainable after clearing Area 8. Below the teleporter, shoot a missile at the weak block, then use the Baby Metroid to clear out the crystals.',
        'Obtainable after clearing Area 8. In the top left of the room before the main room of the Area, there are more blue crystals to clear out.'
      ];
      List<String> lESR = [
        'After receiving the Charge Beam, exit the room and morph under the platform in front of you.',
        'After defeating the rightmost Alpha Metroid, Spider Ball up the right wall, then bomb the corner.',
        'From the Teleporter that leads down to the High Jump Boots, break through the two floors, but instead of going right through the wall, break through the third floor. Continue through these corridors, past the door, and walk past the illusory wall at the end.',
        'On the right side leading to the Alpha Metroid in the lava, below the Charge Beam door, use a bomb on the weakened block.',
        'Right of the second Chozo Seal, break the weakened block on the ceiling. Climb up and through, pull the Grapple block and roll to it.',
        'Obtainable after Area 5. Right of the Zeta Metroid, and below and left of the lava room nearby, is a series of Screw Attack blocks in the ceiling. Break them, and bomb the ceiling using the Spider Ball.',
        'At the top of the main open area, drop in to the ruins and pass through the green door. Go left and drop down, go right and Grapple to pull yourself to it.',
        'Before the second Metroid in the area, drop through the fake floor before the missile in the same room.',
        'From the tall shaft on the upper right side, take the higher left door. Bomb the lower left corner past the water, and drop down. Phase Drift into the left wall and bomb it. Move through there.',
        'In the first room with yellow water, Screw Attack above the second pool. Use the Phase Drift in these tunnels.',
      ];
      List<String> lASR = [
        'Obtainable after Area 5. Return to the Gunship, and fly over the left cliff. Drop down the other side, and go through the door on the right. Shoot a missile right just inside the door, and pull yourself over with the Grapple Beam. Drop down, grapple up, and Phase Drift right.',
        'In the room to the left of where you found the Spider Ball, use it to get to the ceiling, and bomb the weak spot.',
        'Obtainable after Area 8. Right of the lava room, shoot the green substance off the door by shooting the Plasma Beam through the floor. In that room, destroy all the crystals, then climb back up and destroy the missile block through the slit. Get past it quickly.',
        'Obtainable after Area 3. In the tall shaft on the left side, find a weak spot near the bottom. Spider Ball through and up to the top, then Grapple Beam to the left.',
        'Obtainable after Area 5. There\'s a door blocked by a green substance on the way to the Energy Tank behind the High Jump Boots. Open it using your Plasma Beam. Inside, bomb the weak block and activate Phase Drift. Roll back to the vent and shoot a missile at the second block. Quickly roll over to the tank. ',
        'After using the elevator on the right side, crawl through the hole on the right. Yank the Grapple point, then go to the opposite side of it and bomb the wall. Inside, yank another grapple point, and return to that spot and drop down. Bottom the bottom left corner of that room.',
        'Obtainable after Area 4. In the right shaft of the lower trio, find the tunnel leading off to the right. Inside, defeat the creature on the door using the Spazer Beam.',
        'In the top left area, where the Ammo Recharge is, bomb a weak point in the wall on the left. Inside, quickly move through the room with the Lightning Armor to avoid dying from the poison.',
        'In the tunnels where the Diggernaut chase occurred, in the middle floor, you\'ll see this Aeion tank below the floor. Crawl around the left side into the water and destroy the blocks leading into the tunnel. Use the Lightning Armor to get through.',
        'Obtainable after Area 8. In the left side, past the lava room, clear out the blue crystals blocking the way.',
        'In the bottom left area leading towards a Gamma Metroid, there is some water. In the right pool, dive down and Screw Attack through the ceiling inside.',
        'Obtainable after Area 6. In the large chamber at the top, open the Power Bomb on the right side, then use the Lightning Armor to get through.',
        'Left of the last Save station of the Area, before climbing up and left, there should be some flora covering a hole. Use Lightning Armor to get down, and solve the Grapple Block puzzle in the corner between this room and the next (there is a secret block at the top left).',
        'In the long shaft at the top right of the area is a series of red spikes on the right. To the left are more red spikes, but with flora on the bottom. Run through it with Lightning Armor, Spider Ball onto the left wall, line up with the spike tunnel, and use a Power Bomb to launch yourself to the right all the way to the end.',
        'In the bottom left of the area, just past the door beyond the Chozo Seal, use the Screw Attack immediately upon entering into the floor. On the left side below, pull the Grapple block. Go up, Screw Attack through the floor in the next room, climb up, and fire a missile then pull the next block. Return to the other side and repeat in the new hole. Go through the now revealed top right hole.'
      ];
      List<String> lSSR = [
        'Obtainable after Area 5. On the left side of the caverns, above where you slew your first Metroid, open the Plasma Beam door at the top left.',
        'Obtainable after Area 6. Above and left of the gunship, there is a ledge on the far left wall. Place a Power Bomb here, and get onto the right wall ledge.',
        'Obtainable after Area 5. With the Gravity Suit, jump into the lava of the lava room, and follow it to its end.',
        'Obtainable after Area 8. In the room where you got the Ice Beam, break a block on the floor that leads to some crystals. Destroy them and move beyond.',
        'Obtainable after Area 4. In the top left corner of the area map is a Super Missile door. Open it and bomb some hidden blocks and weak blocks to make your own path.',
        'Obtainable after Area 8. In the long shaft on the left side, are some more crystals. Break them, Spider Ball along the ceiling, and bomb the block that hides the expansion.',
        'Obtainable after Area 5. Below where you got the Varia Suit was a blocked passage filled with Screw Attack Blocks. Break through, and blow up the weak block.',
        'Obtainable after Area 5. Located below the lower rightmost elevator. Use the Phase Drift, missiles, and Grapple Beam as needed.',
        'Obtainable after Area 5. At the bottom of the left elevator shaft is an Aeion Recharge. Right of this, in the water is a ledge with a slit past it. Fire a missile, activate Phase Drift, and move through the top, down, and left as fast as possible.',
        'Obtainable after Area 5. In the center right ruins at the top of area 3 lies a Super Missile door. Behind it is a small puzzle, solve it and claim your prize.',
        'Obtainable after Area 5. At the very end of the right side lava tunnels is some... lava. Swim through with the Gravity Suit. Reveal the block with a Super Missile.',
        'After getting Super Missiles, go into the next room and into the water above. Fire a Super Missile up between the spikes and Grapple Beam up.',
        'In the lava room on the rightmost side, hang on to the right ledge of the large platform and fire a Super Missile into the opposing hole in the wall.',
        'Before reaching the Area 5 elevator, you\'ll cross a long pool of purple liquid. At the left end, grapple the red block and fire a Super Missile into the hole.',
        'Obtainable after Area 5. Return to the left half of Area 4, and climb the tall shaft. At the top (past a Grapple block) is a Plasma Beam door. Open it, Phase Drift over the false blocks at the bottom, and Grapple up between the spikes.',
        'Obtainable after Area 8. Above the Diggernaut chase area is an Aeion recharge. From here, go right. Climb into the tunnel, destroy the crystals, then return and open the door from this side. Quickly move around to the other side to go through.',
        'After getting the Phase Drift, go right over the weak blocks and bomb the small hole.',
        'In the main room, go over to the left side and down into the water. Go through the passage and use the Burst Beam to destroy the giant flower. Use the Grapple beam to get past the spikes and use the Spider Ball to get across the ceiling without touching the weak blocks at the bottom.',
        'At the very top of the main room is a small pocket that requires the Screw Attack to get in to.',
        'Located in the center area of Area 5, above the Gravity Suit, next to a Power Bomb Door and above a missile expansion.',
        'In the bottom left corner of the room leading to area 6, left of the Ammo Recharge, Spider Ball up the wall, Phase Drift down onto the false blocks below, and then Screw Attack up to the chamber above to the left.',
        'Obtainable after Area 6. In the top left of the area, break through the Screw Attack walls, and bomb through the false wall and false floor to drop onto an outcropping next to some spikes. Spider Ball onto the right side of this block, and plant a Power Bomb, then pull out the Grapple blocks..',
        'Obtainable after Area 6. On the right wall of the lower right room of the area, plant some bombs to open a hole in the wall next to a platform. Plant a Power Bomb near the vent. Pull out the Grapple block, then cross over through it and go down. Use the Phase Drift and bomb the first weak block, and use a missile on the second from the outside ledge. Pass through, drop down, and Screw Attack back up through that tunnel. Hold left at the end.',
        'Obtainable after Area 8. On the upper right side of the area are some more crystals. Use bombs and Grapple Beam as necessary to move to the end.',
        'In the first large room, take the middle path and bomb the block in the lower corner of the wall. Use the Phase Drift and bomb both the first block in the top right corner and the one behind it, then go back out to the ledge and fire a Super Missile at the third.',
        'From the Ammo Recharge at the very top of the area, go right and bomb through the wall. Cling to the wall and use a Power Bomb to launch yourself, but hold down after you start moving to land in some flora instead of spikes.',
        'In the main room, get into the morph ball maze in the center from the top right of the maze. Bomb the bomb blocks or use the Spider Ball to avoid falling through any of the false blocks.',
        'After Queen Metroid, shortly before the elevator, use the Phase Drift to cross the false floor below some spikes.',
        'After the elevator, destroy some crystals and use the Lightning Armor and Spider Ball to climb the left wall.',
        'Obtainable after Area 8. Destroy the crystals at the top right of the big area below the main room.',
      ];
      List<String> lPSR = [
        'Obtainable after Area 8. Use a Teleporter to get to the right side of the surface. Drop below and destroy the crystals on the left wall.',
        'Obtainable after Area 6. The second lava section contains a Power Bomb hatch. Open it, grapple to the blue block, then Phase Drift to the right and Screw Attack through the wall and ceiling.',
        'Obtainable after Area 8. Near the elevator to Area 3 is a passage to the left. Get inside and destroy the crystals, then bomb the left corner.',
        'Obtainable after Area 8. Above the right side Teleporter is a maze on the left side along the wall. Use the Spider Ball and Baby Metroid to navigate to the end.',
        'Obtainable after Area 8. In the center of Area 3, left of the long lava tunnels on the right side, is a Power Bomb door. Go inside and through the room to the bottom corner.',
        'Obtainable after Area 6. In the upper right corridors, at the bottom next to the Aeion recharge, is some flora. Run through with Lightning Armor.',
        'Obtainable after Area 6. In the upper right section, just above the Save point, is a hole in the wall. Place a Power Bomb at the end, climb through the corridor, and cling on to the wall with Spider Ball. Place another Power Bomb to launch yourself to the end.',
        'Obtainable after Area 8. Below the Chozo Seal that leads to Area 6, there are some crystals on the right wall. Bomb the block behind them.',
        'Obtainable after Area 8. In the section between the two elevators leading to upper Area 5, is a room with a sealed door on one side, and crystals on the other. Approach from the left elevator and move right through those crystals.',
        'Obtainable after Area 6. Get to the top center of the area, and go through the Super Missile door there. In this room (which also contains an Energy Tank), Spider Ball onto the first Grapple block and plant a Power Bomb.',
        'Obtainable after Area 6. In the center areas above the Gravity Suit (where a missile and super missile tank are), complete the Phase Drift through these upper chambers, and finally open the Power Bomb door at the end.',
        'Obtainable after getting the first Power Bomb. Get to the topmost point of the area, and go through the door on the right. Drop down, and open the Power Bomb door. Destroy the two weak points with the required weaponry, then yank the Grapple block and move past it.',
        'After defeating Diggernaut, go into the next room, and place yourself below the opening in the ceiling. Place a Power Bomb, and activate Spider Ball as you hit the ceiling.',
        'Above the Chozo Seal and near the Teleport Statue in this area, is a long L-shaped area of red spikes and poison flora. At the bottom left of this shaft, behind two bomb blocks, place a Power Bomb to launch yourself to the ceiling and latch on with Spider Ball. On the left wall in the center, place another to launch yourself right.',
        'In the main room of the area, go up the right side, and place a Power Bomb near the top. Get into the maze and use the Lightning Armor. Use the Phase Drift as you near the end to avoid falling.'
      ];
      List<String> lOTGSR = [
        'Found very early on in the Surface.',
        'Found past the first Chozo Seal in the beak of a statue.',
        'Found shortly after the first Alpha Metroid in the lower part of the Surface.',
        'After entering the large open area of Area 1, pass into the Save Room that lacks doors, go down, and go left.',
        'Found on the right side of the ruins in the center of Area 1.',
        'Found in the rightmost chamber of Area 1.',
        'Found in Area 2 a few rooms beyond the first Alpha Metroid of the area.',
        'Found at the top of the Area 2 ruins behind a missile door and the Arachnus fight.',
        'Found in the middle of Area 2, above the lava areas.',
        'Found in a room above the Varia Suit, enter via a passage in the central section of Area 2.',
        'Found on the bottom right of Area 2, below a shaft hidden by fake floors and a fake wall.',
        'Found in Area 3, at the top of the first shaft.',
        'Found in Area 3, upon entering the largest room climb up the giant steps and drop down past the next wall, then go left.',
        'Found in Area 4, due left of the first Chozo Seal, at the furthest left lower corner.',
        'Found at the end of the Diggernaut Chase in Area 4.',
        'Found in the upper right portion of Area 4 behind a missile door.',
        'Found early in Area 5, a few rooms after the first Alpha Metroid.',
        'Found in central Area 5, moving up from the first elevator into the upper section and going left after going up and right.',
        'Found in central Area 5, curling in from the left-side elevator into the center rooms. Found in some watery rooms.',
        'Going up the right side of the open-air area in Area 5, take the first door on the left and navigate up and around to the top right corner.',
        'Acquired after killing Diggernaut in Area 6.'
      ];
      for (int i = 1; i <= 80; i++) {
        Hive.box("SamusReturns").put(
            "Missiles $i",
            Item(
                itemType: "Missiles $i",
                itemId: i,
                location: lMSR[i - 1],
                checked: false));
        if (i <= 30) {
          Hive.box("SamusReturns").put(
              "Super Missiles $i",
              Item(
                  itemType: "Super Missiles $i",
                  itemId: i,
                  location: lSSR[i - 1],
                  checked: false));

          if (i <= 15) {
            Hive.box("SamusReturns").put(
                "Aeion Tank $i",
                Item(
                    itemType: "Aeion Tank $i",
                    itemId: i,
                    location: lASR[i - 1],
                    checked: false));
            Hive.box("SamusReturns").put(
                "Power Bombs $i",
                Item(
                    itemType: "Power Bombs $i",
                    itemId: i,
                    location: lPSR[i - 1],
                    checked: false));
            if (i <= 10) {
              Hive.box("SamusReturns").put(
                  "Energy Tank $i",
                  Item(
                      itemType: "Energy Tank $i",
                      itemId: i,
                      location: lESR[i - 1],
                      checked: false));
            }
          }
        }
      }
      Hive.box('SamusReturns').put(
          'Morph Ball',
          Item(
              itemType: 'Morph Ball',
              itemId: 1,
              location: lOTGSR[0],
              checked: false));
      Hive.box('SamusReturns').put(
          'Scan Pulse',
          Item(
              itemType: 'Scan Pulse',
              itemId: 1,
              location: lOTGSR[1],
              checked: false));
      Hive.box('SamusReturns').put(
          'Charge Beam',
          Item(
              itemType: 'Charge Beam',
              itemId: 1,
              location: lOTGSR[2],
              checked: false));
      Hive.box('SamusReturns').put(
          'Bomb',
          Item(
              itemType: 'Bomb',
              itemId: 1,
              location: lOTGSR[3],
              checked: false));
      Hive.box('SamusReturns').put(
          'Ice Beam',
          Item(
              itemType: 'Ice Beam',
              itemId: 1,
              location: lOTGSR[4],
              checked: false));
      Hive.box('SamusReturns').put(
          'Spider Ball',
          Item(
              itemType: 'Spider Ball',
              itemId: 1,
              location: lOTGSR[5],
              checked: false));
      Hive.box('SamusReturns').put(
          'Lightning Armor',
          Item(
              itemType: 'Lightning Armor',
              itemId: 1,
              location: lOTGSR[6],
              checked: false));
      Hive.box('SamusReturns').put(
          'Spring Ball',
          Item(
              itemType: 'Spring Ball',
              itemId: 1,
              location: lOTGSR[7],
              checked: false));
      Hive.box('SamusReturns').put(
          'Varia Suit',
          Item(
              itemType: 'Varia Suit',
              itemId: 1,
              location: lOTGSR[8],
              checked: false));
      Hive.box('SamusReturns').put(
          'Wave Beam',
          Item(
              itemType: 'Wave Beam',
              itemId: 1,
              location: lOTGSR[9],
              checked: false));
      Hive.box('SamusReturns').put(
          'High Jump Boots',
          Item(
              itemType: 'High Jump Boots',
              itemId: 1,
              location: lOTGSR[10],
              checked: false));
      Hive.box('SamusReturns').put(
          'Burst Beam',
          Item(
              itemType: 'Burst Beam',
              itemId: 1,
              location: lOTGSR[11],
              checked: false));
      Hive.box('SamusReturns').put(
          'Grapple Beam',
          Item(
              itemType: 'Grapple Beam',
              itemId: 1,
              location: lOTGSR[12],
              checked: false));
      Hive.box('SamusReturns').put(
          'Spazer Beam',
          Item(
              itemType: 'Spazer Beam',
              itemId: 1,
              location: lOTGSR[13],
              checked: false));
      Hive.box('SamusReturns').put(
          'Space Jump',
          Item(
              itemType: 'Space Jump',
              itemId: 1,
              location: lOTGSR[14],
              checked: false));
      Hive.box('SamusReturns').put(
          'Super Missile',
          Item(
              itemType: 'Super Missile',
              itemId: 1,
              location: lOTGSR[15],
              checked: false));
      Hive.box('SamusReturns').put(
          'Phase Drift',
          Item(
              itemType: 'Phase Drift',
              itemId: 1,
              location: lOTGSR[16],
              checked: false));
      Hive.box('SamusReturns').put(
          'Plasma Beam',
          Item(
              itemType: 'Plasma Beam',
              itemId: 1,
              location: lOTGSR[17],
              checked: false));
      Hive.box('SamusReturns').put(
          'Gravity Suit',
          Item(
              itemType: 'Gravity Suit',
              itemId: 1,
              location: lOTGSR[18],
              checked: false));
      Hive.box('SamusReturns').put(
          'Screw Attack',
          Item(
              itemType: 'Screw Attack',
              itemId: 1,
              location: lOTGSR[19],
              checked: false));
      Hive.box('SamusReturns').put(
          'Power Bomb',
          Item(
              itemType: 'Power Bomb',
              itemId: 1,
              location: lOTGSR[20],
              checked: false));
    }
    if (Hive.box('Dread').isEmpty) {
      List<String> lMMD = [
        'Right of the first save point, destroy the explosive block to open the path.',
        'As you climb up the right side while avoiding the second EMMI you\'ll pass right by this tank out in the open in front of a motion-locked door.',
        'Get to the Map Room of the area, and then climb up and go left through two doors.',
        'At the upper right Network station, use the Charge Beam to open the top right door and head through to see this in a passage you can slide through at the bottom.',
        'In the thermal redirection room on the upper right side of the area you\'ll see this missile tank behind a wall. Fire a missile at standing height towards it, then open the door from there. Go around and through the opened door to grab the tank.',
        'On the right side of the EMMI Zone, above the room where you acquire Omega Energy, is a shaft with Spider Magnet panels running up its height. Climb up the left side and shoot the wall to get to it.',
        'Located through the top left door of the right side Network station, this room must be accessed from the other side on the top floor of the EMMI Zone if you don\'t have the Morph Ball yet. Destroy the explosive parts in order to open a path.',
        'With the Varia Suit, enter the other super-heated zone on the far right side (usually from the Cataris elevator side) and use the Magnet on the top to slide over and drop down onto the tank from above.',
        'With the Varia Suit, enter the super-heated zone on the far right side and climb across the Magnet panels on top.',
        'Right of Missile 1, come back when you have the Flash Shift. Jump up and shift over to the top right corner and bomb the tunnel.',
        'From the lower right Save Room, go left. Drop down, go right, and at the bottom right bomb the block in the way. Jump up.',
        'From the recharge station above the start of the game, climb up to the top left using the Spider Magnet Panel and go through the water.',
        'In the lower right portion of the EMMI Zone is a missile next to a ramp and a Grapple Beam platform in the way. Use the Grapple Beam to raise the platform, then use the Flash Shift to avoid falling down the ramp.',
        'Below the Red Teleportal is some water. On the left side, roll in to the right tunnel after shooting a missile into it.',
        'On returning from Burenia to western Artaria, move into the next room. At the moving platform just ahead, jump over it to avoid changing its position and grab the Missile Tank ahead.',
        'After defeating the Chozo Soldier, climb up to the top of the room on the left.',
        'From the Save Station next to the Red Teleportal, go left, up into the tunnel network and out in the room to the right. Climb up to the top and open the Super Missile barricade. In this room, use bombs on the ceiling to open the path.',
        'Below the Dairon elevator is a shaft of beam destructible blocks. Get to the bottom and go right. Shoot the floor just past the Zone door and drop in. You can also approach this room from the other side using the Speed Booster.',
        'In the huge room in the center, climb up the right side of Magnet panels and go into the hallway. Defeat the enemies and store a Shinespark running right. Quickly shoot the wall, enter Morph Ball in the revealed hole, and Shinespark to the left.',
        'Right of the Chozo Soldier fight, where the Energy Part and Missile+ are, use the Speed Booster down the long ramp to the base, destroying the second edifice in the way with Missiles, and Morph Ball Shinespark right at the end.',
        'With the Screw Attack, go to the elevator to Burenia and use the Screw Attack to go left.',
        'With the Wave Beam, come back to the elevator to Burenia and descend in the next room to the left, past the recharge station and shoot the exploding spot in the wall to open a path to the top right.',
        'Located right next to the left center exit in the EMMI Zone.',
        'Above to Purple Teleportal behind Kraid, grab on to the Magnet Panel and fire a Charge Beam at the wall right next to the Missile Tank and roll through.',
        'In the room above Kraid with the Magnet Panel, drop into the lava below it and swim left. Bomb the last block. Easiest with the Gravity Suit, though possible without.',
        'From the Purple Teleportal room, go right and up into another super-heated room. At the top right are some explosive blocks, break them and roll up to the corner.',
        'From the eastern Save Station, go left and then down and into the morph ball hole on the right. Climb across the Magnet Panel and fire a missile ahead to open up the alcove.',
        'From the room in eastern Cataris with the two Magnet Panels that slide up on either wall, go left and down and take the door on the right into the heated area. Open the other door on the other side of the room and break the block to get up to the missile in the next room.',
        'Make your way up the eastern side of Cataris into the room with the Wide Beam box. Move the box back and bomb the blocks right next to it and shoot the wall on the left side.',
        'From the Network room on the upper left side of the area, go right and down, then use the morph ball to get into the room on the left. Use the Flash Shift to get on to the floating platform and jump up into the alcove.',
        'From the Artarian elevator, go left and drop all the way to the lowest point in the room. Destroy the explosive part of the wall with a charged shot and use the Morph Ball to get through.',
        'Above the bottom Network room is a super-heated room with several platforms. Cross the room and wall jump at the end to get to where the missile tank lays.',
        'Requires the Gravity Suit. From the Orange Teleportal, drop down into the lower section of the room, then go to the left wall of the lava pool. Shoot all the blocks right next to you, start Speed Boosting, and slide under the next wall then run into the end.',
        'Starting from the shuttle to Dairon, Speed Boost to the right, shoot out the lower corner of the wall and slide through, jump across the gap, and retain the Shinespark or Speed Boost while you jump up to the top platform. On its edge, Shinespark straight up into the ceiling.',
        'In the eastmost shaft, climb up to the very top with the Space Jump and shoot the top right corner. Use bombs when you get stopped and after dropping down, go left.',
        'Above the Experiment Z-57 boss room, use the Screw Attack to break into the corner of the room. This area is best re-accessed via the Purple Teleportal room and heading right.',
        'Use Bombs to access the secret path just below the room where you get them.',
        'Next to the western Save Station use bombs on the wall between the two Morph Ball launchers.',
        'From the western Save Station, take the lower Morph Ball Launcher, then shoot the roof and jump up to grab the ledge.',
        'From the western Save Station, go right into the EMMI Zone room closest to the western Save Station. In this room at the top are some Magnet Panels, one of which moves. Use the Speed Booster here to break through the blocks on the right.',
        'In the room between the eastern Save Station and the shuttle to Cataris, activate the Speed Booster and Shinespark straight up in the raised spot in the center of this room.',
        'Make your way to the massive room in the right side of the area. Use the Grapple Beam slots across the top. The Flash Shift can help with the approach.',
        'From the elevator to Ghavoran, go right through the door and grab it.',
        'Requires the Gravity Suit. Starting from the bottom Network station, go right until you get to the room with the long pool of lava on the bottom. Activate the Speed Booster going right.',
        'In the same room as above, climb to the top right corner and use the Grapple Beam to remove a block, then climb into the tunnel.',
        'From the Map Station in the upper left, activate the Speed Booster running left and store the Shinespark as soon as possible. Use it to hit the wall below the Magnet Panel. Below, use the Screw Attack to break the blocks, and go through the tunnel on the right. Use the Speed Booster here to break the blocks on the left.',
        'Requires the Cross Bomb. From the Map Station again, go right and down to the bottom door on the right. On the right side of this room, use one bomb to destroy the first block, and fire four missiles into the hole to destroy the rest. Use a Cross Bomb to launch yourself over the crumbling blocks into the corner.',
        'Go left from the upper Network Station, then go down and right into the next room. Use the Spider Magnet to get on to the right platform next to more water, then charge a Charge Beam shot, jump and release it into the tunnel. Climb through to the end.',
        'In the room to the right of the Map Station and Network Station, climb to the top right, and in the top left corner against the center structure plant a bomb.',
        'When you go through the Plasma Door to enter the lower portion of the main underwater section, use some bombs on the floor of the new room before you go down and you\'ll open a passage to the Missile Tank in this room.',
        'Once you have the Gravity Suit, return to this first underwater room that you had to Space Jump through and Speed Boost across the floor, then Shinespark up right in the center.',
        'Start from the lower shuttle to Dairon with the Gravity Suit and Space Jump. Go left and get to the very bottom of the room. Go left again, and climb up to the top of this small alcove.',
        'At the top of Burenia, below the Drogyga boss room, drop into the water and go to the right, then jump into the tunnel.',
        'With the Screw Attack, come back to Burenia via the Artaria elevator and in the elevator room\'s left side, Screw Attack above the door.',
        'After defeating the two bosses east of the Green Teleportal, climb up to the top left and shoot a missile into the corner of the floor before opening the Charge Beam door.',
        'From Escue\'s boss room, climb up to the top of the room to the right using the beam to break blocks. Shoot a missile at the top right corner to reveal the power-up.',
        'Use the Cyan Teleportal from Burenia, and climb up while shooting the blocks in the way.',
        'Starting from the Network Station in the top left of the area, jump up to the top left corner of the room and plant a Cross Bomb, then climb up through what you just destroyed.',
        'From the upper left shuttle to Ghavoran, go into the room with water below, and use a bomb on the left wall at the same height as the top of the Magnet panel. In the secret room, drop through the first set of crumbling blocks, then Flash Shift left and jump up to the top alcove.',
        'From the same room as above, descend to the bottom and go through the hidden tunnel in the right wall. Go through the floor and next tunnel and in the next room go to the tunnel directly right of the first platform. Use the Cross Bomb on the top right to open the path, then jump in.',
        'From the elevator to Hanubia, go into the low temperature zone, through the Plasma Beam and Grapple Beam doors, and to the bottom right corner of the room beyond. In that corner, start Speed Boosting left, and pass through the Power Beam door. Slide through the wall, and then store a Shinespark. Shoot the blocks below, and yank the grapple beam block below that. Repeat the same process, but this time, Shinespark right where the Grapple Block used to be.',
        'From the Pulse Radar room with the statue, access the tunnelway on the right, and go up at the dead end instead of down. This also leads towards the Orange Teleportal if you\'ve already unlocked it.',
        'From the elevator to Burenia, head left into the large room. Climb to the top left and use the Grapple Blocks to swing to the top right. You can also use the Space Jump, if it\'s available. Use the Flash Shift to help close the gap.',
        'Next to the Super Missile room and elevator to Dairon is a large room with a couple platforms. Below the left platform, climb into the small tunnel after removing the Grapple Block.',
        'In the large room next to the shuttle to Elun, there is a Speed Booster block in the top left blocking the Missile Tank. Charge the Speed Booster in the Shuttle room after opening the door from as far back as you can, and in the room cross the two platform gaps by making well timed jumps, and at the end of the second platform, jump again. Don\'t Shinespark in this room.',
        'In the waters right of the Burenia elevator, drop in, and Space Jump over to the Missile tank.',
        'In the tall shaft on the upper right side of the area, jump into the sloped tunnel on the left wall.',
        'From the shuttle to Hanubia (or at least, the room next to it), drop through the bomb blocks in the floor by the door. Drop through the crumbling blocks and bomb the lower left corner and all its blocks.',
        'Above the Green Teleportal, Screw Attack into the left side ceiling and use the Cross Bomb to get over the crumbling blocks on the right side of the tunnel.',
        'Right below the map room, drop into the water and bomb the lower left corner. Jump up on to the bomb block ledge and plant a bomb, then hold right. When you land on in the tunnel\'s mouth, plant another Cross Bomb to launch yourself to the end over the crumbling blocks.',
        'From the lower right Save Room, go two rooms to the right, and Space Jump to the top of the room. Activate all the Storm Missile switches, then head through the door on the left, and up through the floor into the Green Teleportal room, then head right and up to the corner.',
        'In the lower right corner of the area, activate the Speed Booster into the fan, then Shinespark up along the left wall.',
        'Past the boss room, climb up into the tunnels above, and when you get to the slightly larger spaces, instead of shooting down to drop further, climb up to the top right into the corner and plant a Power Bomb. Above, go left and plant another if needed, then go further left.',
        'Approach the room left of the elevator to Ferenia or the area leading from the lower right of the Save Station. In this room on the left, open the Grapple Block and use bombs (or the Screw Attack) as necessary to get through the tunnels to the top center.',
        'Located directly below the Total Recharge station that appears right before the Elite Chozo Soldier fight at the top right of the area.',
      ];
      //formatting rule exception below, cannot find a good shorthand for "Missile+", so Super will substitute
      List<String> lSMD = [
        'After the Chozo Soldier fight in the cold room on the lower left, behind Energy Part 2, are some walls. Use the long corridors nearby and use the Speed Booster to break through all of the obstructions leading to the top right. The last set is only one block tall, so slide through it instead of running.',
        'Requires the Gravity Suit. Below the Varia Suit in the closest lava room at the top left, drop down to the bottom and swim into the lava to the left all the way to the end.',
        'Near the Red Teleportal and leftmost Save Room is a series of Morph Ball tunnels. Climb in and go to the far right edge.',
        'In the connecting tunnel between the two parts of the EMMI Zone of the area on the lower left, start a Speed Boost in the lower right EMMI Zone running into the tunnel. Use wall jumps, spin jumps, and slides to maintain that Speed Boost into the next room, and at the top right are some Speed Booster blocks for you to break through above and opposite the Storm Missile Box.',
        'In the first major underwater room, climb onto the top left platform.',
        'In the lower right corner, above the structure that you destroyed, use the Screw Attack and Space Jump to get up to the very top and break through the blocks there.',
        'Head left from the map room and climb up to the Spider Magnet. Fire a missile to open the tunnel, then Flash Shift or Spin Boost over to the tunnel.',
        'From the Green Teleportal, drop down through the secret tunnel and past the fire barriers, and walk through the door to the right. Don\'t drop down at the end and instead start Speed Boosting left. Charge and activate Shinespark right before the edge, and keep running through. In the next areas you will need to: slide under the wall, shoot the blocks below you, Shinespark left up the hill, slide under the wall, drop down and Shinespark right up the hill, stop and charge Shinespark atop that hill, drop down, and Shinespark right to the end.',
        'Right of the left elevator to Dairon, there is a tank stuck in a square space. Charge a Speed Boost from the room above to the left running back into this room, and store a Shinespark when you enter. Shoot the beam blocks on the left side below the door, then shinespark through the wall on the left below the beam blocks. Alternatively, use the fan to charge the Speed Boost and sustain the charge using Shinesparks in the room sporadically.',
        'In the lower parts of the area, in the room above where you found the Super Missile, climb into the small tunnel in the top right corner.',
        'At the top left next to the shuttle from Ghavoran, charge a Speed Boost from the shuttle room into the one next to it. Store a Shinespark on the right side and hop up to the top area. Destroy the beam blocks in front of you, bomb the center of the tunnel, then Shinespark up to the top.'
      ];
      //P is consumed by power bomb, so Energy Tank and Part are split to T and E respectively, as opposed to Tank being E.
      List<String> lEMD = [
        'With the Morph Ball, go to the top left Save Room and climb up to the ledge just outside on the left.',
        'After the Chozo Soldier boss battle in the cold room on the lower left, head right and find this on a ledge.',
        'In the same room as Energy Tank 3, proceed to the left on the lower portion after pulling the wall down, and slide under the wall segment at the top.',
        'With the Gravity Suit, return to near the Purple Teleportal. Drop below and shoot out the fake floors and go into the lava. Use a Power Bomb at the lower right tunnel to break the walls above it, and then use the Speed Booster to run to the end. Shinespark straight up at the end after the drop.',
        'After getting the Speed Boost, make sure you\'re in the lower left chamber of the Dairon EMMI Zone, and on the upper middle platform\'s right side are some cracked blocks. Speed Boost through them to open the path.',
        'In the lava section right of the bottom network room, bring the Gravity Suit (or a lot of health and confidence) to grab the Energy Tank by rolling inside into the lava and jumping up.',
        'Below the left-side elevator to Ferenia, enter the EMMI Zone. This time, activate the Speed Booster running right across the middle platform to breakt through some walls, and in between those walls, shoot a missile and plant a bomb on the right corner of the tunnel above. Using a Power Bomb will make this easier.',
        'In the frozen room at the top left, get on the bottom floor and charge a Shinespark towards the left side. Use the Shinespark to get up to the ceiling and to destroy the Speed Booster blocks on the left side, then walk through the door.',
        'In the early areas of Burenia, entering from the upper Dairon shuttle, is a strong fan blowing past the Energy Part. Use the Speed Booster to run right through.',
        'Requires the Ice Missile. At the Green Teleportal, bomb the lower right corner to open a path. Destroy the flaming barriers and go through the door to the bottom right.',
        'In the lower right rooms, above the Storm Missile and its associated boss, bomb the block in the way to reach this at the bottom of the room.',
        'From the right Dairon elevator, climb up into the chamber with the Spider Magnet panels and Spin Boost your way to the top right corner ledge, then bomb the blocks.',
        'From the left Dairon elevator, start Speed Boosting into the chamber on the left (slide under the wall), and use a combination of the Speed Boost and Shinespark to ascend both this first ramp and the next one above it and Shinespark up after that second ramp ends.',
        'Right of the Twin Robot Chozo Soldier battle, you\'ll find a room with a Storm Missile box and a recharge station. Use the Screw Attack at the top of the room to get into an alcove of bomb blocks. Roll through the tunnel at the top and plant a Cross Bomb as you fall. Quickly return to the left side and pull the Grapple Block on the right out of place. Climb into that tunnel and bomb your way through to the center to find the Energy Part.',
        'Near the shuttle to Hanubia and the upper right Save Room is a very tall shaft. Use the Speed Booster along the floor to Shinespark up the center.',
        'In the large main shaft of Ghavoran, on the left side, is a Grapple Block. Land on the platform next to it and immediately pull the block. Climb back up when the platform regenerates and go into the hole you created.',
      ];
      List<String> lTMD = [
        'Located on the right side of the lowest section of Artaria, found after getting the Charge Beam.',
        'Requires the Speed Booster. In the upper left corner of Artaria, past where the Varia Suit was, destroy the Grapple block, then return to the right side. Start running left, and store a Shinespark just before that wall, then roll in and bomb the two bomb blocks. Flash Shift to the left wall and Shinespark straight up.',
        'On the top right side of Cataris you\'ll spy this tank above a device to divert the heat. Enter this room from below once the heat is gone and pull the Spider Magnet wall down. Return to that space from the right and jump up.',
        'In the largest centermost EMMI Room of the area along the right side is a long shaft with a few platforms in the way. Run along the bottom of the room and Shinespark straight up at the right end, and you\'ll find this in an alcove on the left side at the top.',
        'Above the Flash Shift and the higher western Save Station is a hallway with some water below and a Spider Magnet panel at the end. Use the Flash Shift to get to the panel and go up to the left.',
        'Deep below the waters of the first major shaft in this area you will enter a room with Spider Magnet panels on the right and Storm Missile boxes across the top. Open the Storm Missile Box and climb up to the top left.',
        'Near the top of the main shaft in Ghavoran is a flaming barrier. Destroy it with an ice missile and find this right behind.',
        'In the room left of the boss room, next to the tunnel entry that takes you all the way around the area, is another destructible part of the ceiling. Break the blocks and plant a bomb in the revealed corner to gain access.',
      ];
      List<String> lPMD = [
        'Use the Spider Magnet to get to the top of the largest chamber in this EMMI Zone and climb left.',
        'Go two rooms left of the Map Station. On the lower left of this room is a morph ball tunnel covered by a fake block. Go above this and through the door, then turn around and use the Speed Booster. Slide under the obstruction, store a Shinespark, and go into the tunnel. Drop down on the left, and activate the Shinespark to the right.',
        'From the eastern Save station, go directly right into the room with the moving Spider Magnet panels. Get up to the top right side, shoot the blocks in the way, and open the Grapple Beam door. Hang on the blue platform from below, shoot the first block on the right, and put Bombs on the two left. Make the platform descend a bit, then destroy the remaining blocks with missiles.',
        'Return to Kraid\'s room, dive into the lava with the Gravity Suit, and work your way through the tunnels on the right side up to the top right.',
        'In Dairon, enter the superheated room right next to the Artaria Elevator. Jump up to the Spider Magnet Panel and shoot two missiles to the right.',
        'In lower left Dairon there is one large isolated area that bridges two parts of the EMMI Zone. In there, open the Storm Missile Box, and use a Cross Bomb to destroy all the bomb blocks at the top and use the Grapple Beam to remove the Grapple block. Climb up from below.',
        'Below the left-side elevator to Ferenia, enter the EMMI Zone. Plant a Power Bomb on the central platform to the left to open the path.',
        'Get to the very bottom of the area, best accessed from the left side, to right below the Gravity Suit room. Below the door is an additional small area, plant a Power Bomb inside to open a tunnel. Return to the long hallway and charge a Speed Booster, store a Shinespark, and activate it to the right below the Power Bomb block you destroyed.',
        'Above where you fought the Twin Robot Chozo Soldiers use a Power Bomb at the top center of the central platform.',
        'In the lowest room of the EMMI Zone, near the eastern elevator to Dairon, use a Power Bomb to reveal a hole in the roof, then use the Space Jump to ascend into the alcove.',
        'Located at the highest point of the central shaft, left of the Orange Teleportal and right of the EMMI Zone.',
        'Left of the boss room, get up to the top of the room and into the tunnels. Go around the lengthy tunnel area down to the right side and find this above the Grapple Beam block.',
        'Top right of the Network Station in this area, get to the upper left exit of the EMMI Zone. Activate the Speed Booster running left, and in the next room, charge a Shinespark before you fall off the ledge. Bomb the blocks immediately to the right, and Shinespark straight down.',
      ];
      List<String> lOTGMD = [
        'Left of the Energy Recharge in lower Artaria, destroy the fake block below the door, open the missile barricade below, drop down, and slide under the door to the left.',
        'Defeat the White EMMI in Artaria.',
        'Defeat Corpious in Artaria.',
        'In Dairon, activate the generator in the eastern portion, then go up-right through the door and the missile barricade.',
        'Defeat the Green EMMI in Cataris.',
        'After recovering the Morph Ball, exit through the left EMMI Zone door, drop down through the tunnels, and go through the skull structure. Shoot the secret entrance above the door, and use the Red Teleportal above. Now in Artaria, go up and follow the path to its logical end.',
        'After defeating Kraid, go right and climb up the Spider Magnet walls to the tunnel. Proceed right, drop down and open the missile barricade.',
        'In Dairon, activate the generator in the northwestern area, then go right and open the missile barricade above.',
        'In Burenia, climb up the right side of the first major underwater area you enter. At the top, above the water, open the missile barricade.',
        'Defeat the Yellow EMMI in Dairon.',
        'Located at the top of Artaria, below the elevator to Dairon. Go right of the northern Save station and open the door and missile barricade.',
        'Located in southern Ghavoran, go left from the elevator to Dairon, open the door, drop down, and bomb the block in the corner, then open the missile barricade.',
        'Located in southwestern Elun, from the main entrance, drop through the tunnel network, go around and up through the Power Beam door, then drop down and bomb the floor. Continue to the tunnel/morph ball launcher at the bottom, open the missile barricade, and shoot the roof.',
        'In central Ghavoran, left of the top right Save Point, is a single underwater room. Drop into the water and go right, and use the Morph Ball Launcher.',
        'Defeat the Blue EMMI in Ghavoran.',
        'Use the Red Teleportal to enter Cataris, and from there go to the Orange Teleportal to Ghavoran. Drop down and go left in the tunnel network instead of down. Slide below the door in the next chamber.',
        'Defeat Escue in eastern Ferenia.',
        'In upper Ferenia, entering from Ghavoran, destroy the Storm Missile box just one room over from the Ghavoran shuttle, and then destroy the missile barricade.',
        'In Burenia, now with the Space Jump, start below where you found the Flash Shift and cross the gap to the left and grab the Spider Magnet. Repeat and go through the door. Travel through the next few chambers, and at the top of the next large one, destroy the Grapple Beam block below to open a path. Open the missile barricade on the bottom left.',
        'Use the Blue Teleportal from Cataris to Artaria. Remove the Grapple Block, then head through the Plasma Beam door below. Enter the passage on the wall and drop down.',
        'Defeat Golzuna in Ghavoran.',
        'Defeat the Purple EMMI in Ferenia.',
        'Defeat the Red EMMI in Hanubia.'
      ];
      for (int i = 1; i <= 75; i++) {
        Hive.box('Dread').put(
            "Missiles $i",
            Item(
                itemType: "Missiles $i",
                itemId: i,
                location: lMMD[i - 1],
                checked: false));
        if (i <= 16) {
          Hive.box('Dread').put(
              "Energy Part $i",
              Item(
                  itemType: "Energy Part $i",
                  itemId: i,
                  location: lEMD[i - 1],
                  checked: false));
          if (i <= 13) {
            Hive.box('Dread').put(
                "Power Bomb $i",
                Item(
                    itemType: "Power Bomb $i",
                    itemId: i,
                    location: lPMD[i - 1],
                    checked: false));
            if (i <= 11) {
              Hive.box('Dread').put(
                  "Missile+ Tank $i",
                  Item(
                      itemType: "Missile+ Tank $i",
                      itemId: i,
                      location: lSMD[i - 1],
                      checked: false));
              if (i <= 8) {
                Hive.box('Dread').put(
                    "Energy Tank $i",
                    Item(
                        itemType: "Energy Tank $i",
                        itemId: i,
                        location: lTMD[i - 1],
                        checked: false));
              }
            }
          }
        }
      }
      Hive.box("Dread").put(
          'Charge Beam',
          Item(
              itemType: 'Charge Beam',
              itemId: 1,
              location: lOTGMD[0],
              checked: false));
      Hive.box("Dread").put(
          'Spider Magnet',
          Item(
              itemType: 'Spider Magnet',
              itemId: 1,
              location: lOTGMD[1],
              checked: false));
      Hive.box("Dread").put(
          'Phantom Cloak',
          Item(
              itemType: 'Phantom Cloak',
              itemId: 1,
              location: lOTGMD[2],
              checked: false));
      Hive.box("Dread").put(
          'Wide Beam',
          Item(
              itemType: 'Wide Beam',
              itemId: 1,
              location: lOTGMD[3],
              checked: false));
      Hive.box("Dread").put(
          'Morph Ball',
          Item(
              itemType: 'Morph Ball',
              itemId: 1,
              location: lOTGMD[4],
              checked: false));
      Hive.box("Dread").put(
          'Varia Suit',
          Item(
              itemType: 'Varia Suit',
              itemId: 1,
              location: lOTGMD[5],
              checked: false));
      Hive.box("Dread").put(
          'Diffusion Beam',
          Item(
              itemType: 'Diffusion Beam',
              itemId: 1,
              location: lOTGMD[6],
              checked: false));
      Hive.box("Dread").put(
          'Morph Ball Bomb',
          Item(
              itemType: 'Morph Ball Bomb',
              itemId: 1,
              location: lOTGMD[7],
              checked: false));
      Hive.box("Dread").put(
          'Flash Shift',
          Item(
              itemType: 'Flash Shift',
              itemId: 1,
              location: lOTGMD[8],
              checked: false));
      Hive.box("Dread").put(
          'Speed Booster',
          Item(
              itemType: 'Speed Booster',
              itemId: 1,
              location: lOTGMD[9],
              checked: false));
      Hive.box("Dread").put(
          'Grapple Beam',
          Item(
              itemType: 'Grapple Beam',
              itemId: 1,
              location: lOTGMD[10],
              checked: false));
      Hive.box("Dread").put(
          'Super Missile',
          Item(
              itemType: 'Super Missile',
              itemId: 1,
              location: lOTGMD[11],
              checked: false));
      Hive.box("Dread").put(
          'Plasma Beam',
          Item(
              itemType: 'Plasma Beam',
              itemId: 1,
              location: lOTGMD[12],
              checked: false));
      Hive.box("Dread").put(
          'Spin Boost',
          Item(
              itemType: 'Spin Boost',
              itemId: 1,
              location: lOTGMD[13],
              checked: false));
      Hive.box("Dread").put(
          'Ice Missile',
          Item(
              itemType: 'Ice Missile',
              itemId: 1,
              location: lOTGMD[14],
              checked: false));
      Hive.box("Dread").put(
          'Pulse Radar',
          Item(
              itemType: 'Pulse Radar',
              itemId: 1,
              location: lOTGMD[15],
              checked: false));
      Hive.box("Dread").put(
          'Storm Missiles',
          Item(
              itemType: 'Storm Missiles',
              itemId: 1,
              location: lOTGMD[16],
              checked: false));
      Hive.box("Dread").put(
          'Space Jump',
          Item(
              itemType: 'Space Jump',
              itemId: 1,
              location: lOTGMD[17],
              checked: false));
      Hive.box("Dread").put(
          'Gravity Suit',
          Item(
              itemType: 'Gravity Suit',
              itemId: 1,
              location: lOTGMD[18],
              checked: false));
      Hive.box("Dread").put(
          'Screw Attack',
          Item(
              itemType: 'Screw Attack',
              itemId: 1,
              location: lOTGMD[19],
              checked: false));
      Hive.box("Dread").put(
          'Cross Bomb',
          Item(
              itemType: 'Cross Bomb',
              itemId: 1,
              location: lOTGMD[20],
              checked: false));
      Hive.box("Dread").put(
          'Wave Beam',
          Item(
              itemType: 'Wave Beam',
              itemId: 1,
              location: lOTGMD[21],
              checked: false));
      Hive.box("Dread").put(
          'Power Bomb',
          Item(
              itemType: 'Power Bomb',
              itemId: 1,
              location: lOTGMD[22],
              checked: false));
    }
    if (Hive.box('Prime').isEmpty) {
      List<String> lMP1 = [
        '(Landing Site) Requires the Morph Ball. Find the small alcove covered in Tangle Weeds next to the ship.',
        '(Transport Tunnel B) Look under the rocky bridge to find this in the dirt.',
        '(Overgrown Cavern) Take the elevator from the Chozo Ruins near the Reflecting Pool (Tallon Overworld East Elevator) and find this in the middle of some Venom Weed.',
        '(Frigate Crash Site) Hidden in a small cave underwater near the tree roots. Requires the Gravity Suit.',
        '(Biohazard Containment) Use the Scan Visor in the underwater segment to find a Cordite door on the wall. Break it with a Super Missile.',
        '(Arbor Chamber) Use the Grapple Beam in the Root Cave to reach the upper part. Use the X-Ray Visor to reveal some invisible platforms and climb up to the red door.',
        '(Root Cave) On the way up to the previous missile, use the X-Ray Visor to reveal a hidden alcove in the wall behind some vines.',
        '(Great Tree Chamber) In the upper area of the Great Tree Hall is an invisible platform leading to a door you normally can\'t reach.',
        '(Life Grove Tunnel) Accessed via the Great Tree Hall. Use the Morph Ball to reach an underground O-shaped tunnel, and use the Boost Ball reach the top. Bomb the middle of the ground to fall through.',
        '(Hive Totem) Found after defeating the Hive Mecha.',
        '(Main Plaza) Hidden in an alcove above the half-pipe. Requires the Boost Ball.',
        '(Main Plaza) Accessed via the Training Chamber, use the Grapple Beam to get to the other side.',
        '(Main Plaza) On the large tree is a large knot that can be scanned. Destroy it with a Super Missile.',
        '(Ruined Nursery) Located at the end of the tunnels in the walls. Use bombs to break the metal blocks.',
        '(Ruined Gallery) On the right side of the room as you enter are two openings. Enter the tunnel with the Morph Ball.',
        '(Ruined Gallery) Use a missile to break a weakened wall across the shallow pond below the door.',
        '(Ruined Shrine) Use the Boost Ball to reach an opening high on the left (left side from the main entrance) wall.',
        '(Ruined Shrine) Use a bomb to open a tunnel on the floor of the room (right side from the main entrance).',
        '(Vault) Use a double bomb jump to get into each of the locks and plant a bomb to deactivate them.',
        '(Ruined Fountain) Use the fountain to propel up to the Spider Ball track in Morph Ball mode.',
        '(Gathering Hall) Requires the Space Jump Boots, or skill with double bomb-jumps. At the top of the room is a metal grate. Bomb it, and jump up above.',
        '(Watery Hall Access) Use a missile at the foot of the stairs to break through the crumbling wall.',
        '(Watery Hall) After defeating Flaahgra, use the Gravity Suit to find an underwater tunnel.',
        '(Burn Dome) After defeating the Incinerator Drone, use a bomb to break the Sandstone wall.',
        '(Furnace) Use a Power Bomb below the Spider Ball tracks to reveal a half-pipe. Boost Ball to reach a Spider Ball track above that and roll to the top of the room. Bomb the parasites to not get knocked off.',
        '(Dynamo) Blast open the grating on the wall opposite the door to reveal an alcove.',
        '(Dynamo) Climb the Spider Ball track.',
        '(Crossway) Blow up the Cordite covering a console beyond the halfpipe. Scan it, then Boost Ball to the Morph Ball slots using the Spider Ball track and halfpipe. Drop down and ride the elevator.',
        '(Training Chamber Access) Near the door is a large tree, roll through it to reveal a hidden tunnel.',
        '(Storage Cavern) In the Triclops Pit, use the Morph Ball to get into the area under the floor and go to the opening opposite the lava.',
        '(Triclops Pit) Requires the Space Jump Boots and X-Ray Visor. Use the X-Ray to reveal invisible platforms and jump up to the blank pillars. Break it with a missile.',
        '(Fiery Shores) In one corner are some raised catwalks. Get up there with bombs, then carefully roll along.',
        '(Phendrana Shorelines) Hidden in the corner, encased in ice. Melt it with the Plasma Beam.',
        '(Phendrana Shorelines) On the ledge where the temple structure resides, use the Scan Visor to reveal a weakened structure. Destroy it with a Super Missile and scan the console beneath to reveal a Spider Ball track on the left tower. Follow it.',
        '(Ice Ruins East) In one of the corners among the ruined buildings is a hidden Spider Ball track. Follow it.',
        '(Ice Ruins East) Around the corner from the entrance is a small cave covered in ice. Melt it with the Plasma Beam.',
        '(Research Lab Hydra) On the top floor is a cylindrical container with fractures in it. Use a Super Missile on it.',
        '(Research Lab Aether) Tucked away behind some narrow catwalks about halfway up.',
        '(Frost Cave) Requires the Grapple Beam. Break a stalactite to reveal a Grapple Point to get up to the highest point in the room. Break the highest stalactite in the room, and jump down into the water below.',
        '(Gravity Chamber) Requires the Grapple Beam and Plasma Beam. Above the area where you find the Gravity Suit is a giant stalactite. Blast it with the Plasma Beam, and use the Grapple Point behind it.',
        '(Quarantine Monitor) Requires the Grapple Beam. In the Quarantine Cave (where you fought Thardus), use the Spider Ball to reach the door to the elevator. From there, use the Grapple Points to get to the far side to the door.',
        '(Main Quarry) Clear out the Pirates, then head to the top where the crane is. Use the Thermal Visor and activate the electrical conduit. Scan the console to activate the crane, and use the Spider Ball tracks to go up into the destroyed wall.',
        '(Security Access A) Break open the weakened wall with a Power Bomb. Use the Scan Visor to find it.',
        '(Elite Research) Use the spinner at the top to aim the laser 270 degrees away from where it starts. Activate it to destroy the wall and reveal the missile.',
        '(Elite Control Access) There is a crate on a ledge not far from the door. Shoot it to blow up a wall section and reveal a missile.',
        '(Phazon Processing Center) In this massive chamber is a platform with some crates resting against the far wall (opposite the red door). Use the X-Ray Visor there and use a Power Bomb where you see the missile tank behind the wall.',
        '(Metroid Quarantine A) Once you reach the Spider Ball tracks leading to the door at the far side, scan for a weak wall. Use a Power Bomb on both this wall and the next one after it to reach another Spider Ball track. At the end, look for an invisible platform with the X-Ray Visor and ride it up.',
        '(Fungal Hall Access) At the bottom is a large mushroom. After getting the Phazon Suit, come back and go underneath.',
        '(Fungal Hall B) Near the door leading out, bomb the ground in front of the cliff. Use Thermal or X-Ray vision if you can\'t see.',
        '(Metroid Quarantine B) Destroy one of containers past the force field with a Super Missile.'
      ];
      List<String> lEP1 = [
        '(Cargo Freight Lift to Deck Gamma) Within the ruins of the Pirate Frigate is a concealed Energy Tank behind a wrecked elevator underwater. Use a missile to destroy the metal door.',
        '(Hydro Access Tunnel) At a different point in the ruined Frigate, use timed Bomb jumps to ascend the shaft in the center of the region.',
        '(Main Plaza) Visible in the top corner, access this area via the Vault.',
        '(Transport Access North) After getting your first missile, head past the ruined Hive Mecha to find this sitting there.',
        '(Furnace) Go through the opening next to the Spider Ball track to reach an enclosure inside the Furnace.',
        '(Hall of the Elders) Activate the Ice Beam lock in this room, and let the statue send you to it.',
        '(Training Chamber) After defeating the Chozo Ghosts, use the Boost Ball to get to a Morph Ball slot that calls down an elevator near the exit. Follow the Spider Ball track above.',
        '(Transport Tunnel A) This narrow tunnel leads to an elevator to Phendrana. Inside, you\'ll need to get high up to the top by performing three successful double bomb jumps.',
        '(Magmoor Workstation) Charge the three conduits to power up the lava pump (using the Thermal Visor and Wave Beam), then go below the grate, and make it to the third room.',
        '(Ruined Courtyard) Activate two Morph Ball Slots and a Spinner to raise the water level, then head to the opening on the far wall that is now reachable. Use the Morph Ball to reach a hidden room.',
        '(Research Lab Aether) Break the glass container on the ground floor with a missile.',
        '(Transport Access) Visibly locked behind a wall of ice. Melt it with the Plasma Beam',
        '(Ventilation Shaft) Use a Power Bomb to break a grate near one of the fans (quickly) and activate the terminal behind it. Head into the now destroyed opposite fan.',
        '(Processing Center Access) After defeating the Omega Pirate, head through the red door above.'
      ];
      List<String> lPP1 = [
        '(Magma Pool) Requires the Grapple Beam and Power Bomb. Use the Grapple Beam to get to the far side of the cavern, then plant a Power Bomb and go inside.',
        '(Warrior Shrine) Accessed via the Monitor Station. Find the metal grate over the opening in front of the Chozo Statue with the artifact, and use a Power Bomb there.',
        '(Ice Ruins West) From the entrance to the left is a building with Crystallites at the top. Make it up to the top and melt the ice with the Plasma Beam.',
        '(Security Cave) At the top of Phendrana\'s Edge is an opening leading to this room. Use the Grapple Beam on the glider flying around the Edge.',
        '(Central Dynamo) The first Power Bomb you find. Defeat the sentry drone, and navigate the electric maze to the center.'
      ];
      List<String> lAP1 = [
        '(Artifact Temple) [Artifact of Truth] The first artifact you find, right in the center of the totems.',
        '(Life Grove) [Artifact of Chozo] Found in the same room as the X-Ray Visor. In the main area of the room, you\'ll fight three Chozo Ghosts, then jump into the pool and bomb the metal grate. Use the spinner at the base of the revealed pillar and reveal the alcove containing the artifact.',
        '(Tower Chamber) [Artifact of Lifegiver] Beyond the Tower of Light (where the Wavebuster is) is the Tower Chamber. The Gravity Suit is necessary here. Go through the tunnel at the base of the tower in the water, go through and up the door in the roof.',
        '(Sunchamber) [Artifact of Wild] Return to where you faced Flaahgra via the Sun Tower, and defeat the three Chozo Ghosts.',
        '(Elder Chamber) [Artifact of World] Open the Plasma Beam lock in the Hall of the Elders puzzle, and go through the revealed door.',
        '(Lava Lake) [Artifact of Nature] Use missiles to break open the large rocky pillar in the center of one of the lakes, and Space Jump up to it.',
        '(Warrior Shrine) [Artifact of Strength] Access this room via the Monitor Station. Get to the top of the large structure in the Monitor Station with the Space Jump boots, and activate the Spinner to raise a bridge. Jump from it up over to the rocky ledge and walk to the door.',
        '(Control Tower) [Artifact of Elder] Clear the Flying Pirate in the area, and get up to the tower above the door leading to the East Tower. Destroy the crates and melt the ice, then fire a missile through the window to destroy the tower in the distance, and move through the ruined wall.',
        '(Chozo Ice Temple) [Artifact of Sun] On the way to the Wave Beam room is a giant winged Chozo Statue. Melt the ice in the mouth with the Plasma Beam, then Morph Ball into its hands. Roll through the new opening.',
        '(Storage Cave) [Artifact of Spirit] Past Phendrana\'s Edge, near the hidden Power Bomb here, is a door behind a rock wall. Use the X-Ray Visor to find it, and destroy the wall with a Power Bomb.',
        '(Elite Research) [Artifact of Warrior] Use a Power Bomb to blow up the container holding the Phazon Elite, then kill it to earn the Artifact.',
        '(Phazon Mining Tunnel) [Artifact of Newborn] Down in the depths is a long winding tunnel covered in Phazon. Requires the Phazon Suit to survive.'
      ];
      List<String> lOTGP1 = [
        '{Chozo Ruins} (Hive Totem) Defeat the Hive Mecha to reveal it.',
        '{Chozo Ruins} (Ruined Shrine) Defeat the enemies the sprout up in this room.',
        '{Chozo Ruins} (Watery Hall) Scan the four symbols along the walls and floors to open the gate at the end.',
        '{Chozo Ruins} (Burn Dome) Defeat the Incinerator Drone and Ram War Wasp Hive.',
        '{Chozo Ruins} (Sunchamber) Defeat Flaahgra.',
        '{Phendrana Drifts} (Phendrana Canyon) Climb up above to reach a terminal that aligns the floating platforms. Cross the room to the tower.',
        '{Tallon Overworld} (Alcove) After acquiring the Boost Ball, from the Tallon Canyon, use the half-pipe with Beetles to get up to the platform. Follow the path back to the Landing Site, and jump over the gap into another side room you haven\'t been to yet.',
        '{Phendrana Drifts} (Chapel of the Elders) Requires the Space Jump Boots. In the Chapel, defeat the fully-grown Sheegoth.',
        '{Phendrana Drifts} (Observatory) It lies at the top of the holographic projector. Activate the hologram with the spinners and terminals, then jump up the platforms.',
        '{Phendrana Drifts} (Research Core) Defeat the Flying Pirates and turrets, and scan the terminals to remove the force field blocking the upgrade.',
        '{Phendrana Drifts} (Quarantine Cave) Defeat Thardus.',
        '{Chozo Ruins} (Antechamber) After getting the Wave Beam and Spider Ball, go to the Furnace, and up the Spider Ball tracks, and in the room with the pool and Stone Toads, destroy the grate in the water. Boost Ball to the top and go through the Wave Beam door.',
        '{Phendrana Drifts} (Gravity Chamber) Requires the Ice Beam. Go past where you fought Thardus, and past the elevator to Magmoor. Make your way though the maze to the Gravity Chamber, and navigate through to the second cavern.',
        '{Phazon Mines} (Central Dynamo) Defeat the invisible Sentry Drone, then drop into the electric maze and make your way to the center.',
        '{Phazon Mines} (Storage Depot B) Blow up the debris blocking the door at the top of the Ore Processing room with a Power Bomb.',
        '{Tallon Overworld} (Life Grove) Requires the Power Bomb. Beyond the wrecked Frigate is the Great Tree Hall. Make your way to the top with the Spider Ball tracks, and blow up the rock in the cave with a Power Bomb. Use the Boost Ball to get through the tunnel.',
        '{Chozo Ruins} (Tower of Light) From the Main Plaza, go to the room where you found the Morph Ball. Use the Boost Ball to reach the Spider Ball track and carry on. At the logical end of this area is the room, with the item at the top. Shoot the weak walls around the room with Missiles to bring the tower crashing down into reach.',
        '{Magmoor Caverns} (Shore Tunnel) In the plain metal tunnel, look for cracks at the bottom and use a Power Bomb to break through below.',
        '{Magmoor Caverns} (Plasma Processing) Requires most prior upgrades. In the Geothermal Core, use the Grapple Beam to jump up to the pillars. Use the Spinner slots and Spider Ball tracks to reach the top of the three pillars. Activate the Morph Ball slot up there. Make your way up the revealed Spider Ball tracks and use a Power Bomb on the tracks to destroy the rubble blocking the door. Go through the door.',
        '{Phazon Mines} (Storage Depot A) Requires a Power Bomb. In the Mine Security Station is a red door blocked by a force field. Above it is a wall blocking a terminal. Destroy the wall with a Power Bomb and activate the terminal, then go through the door.',
        '{Phazon Mines} (Elite Quarters) Defeat the Omega Pirate.',
        '{Phazon Mines} (Elite Quarters) Received with the Phazon Suit.'
      ];
      for (int i = 1; i <= 50; i++) {
        Hive.box("Prime").put(
            "Missile Expansion $i",
            Item(
                itemType: "Missile Expansion $i",
                itemId: i,
                location: lMP1[i - 1],
                checked: false));
        if (i <= 14) {
          Hive.box("Prime").put(
              "Energy Tank $i",
              Item(
                  itemType: "Energy Tank $i",
                  itemId: i,
                  location: lEP1[i - 1],
                  checked: false));
          if (i <= 12) {
            Hive.box("Prime").put(
                "Chozo Artifact $i",
                Item(
                    itemType: "Chozo Artifact $i",
                    itemId: i,
                    location: lAP1[i - 1],
                    checked: false));
            if (i <= 5) {
              Hive.box("Prime").put(
                  "Power Bombs $i",
                  Item(
                      itemType: "Power Bombs $i",
                      itemId: i,
                      location: lPP1[i - 1],
                      checked: false));
            }
          }
        }
      }
      Hive.box("Prime").put(
          "Missile Launcher",
          Item(
              itemType: "Missile Launcher",
              itemId: 1,
              location: lOTGP1[0],
              checked: false));
      Hive.box('Prime').put(
          'Morph Ball',
          Item(
              itemType: 'Morph Ball',
              itemId: 1,
              location: lOTGP1[1],
              checked: false));
      Hive.box('Prime').put(
          'Charge Beam',
          Item(
              itemType: 'Charge Beam',
              itemId: 1,
              location: lOTGP1[2],
              checked: false));
      Hive.box('Prime').put(
          'Morph Ball Bomb',
          Item(
              itemType: 'Morph Ball Bomb',
              itemId: 1,
              location: lOTGP1[3],
              checked: false));
      Hive.box('Prime').put(
          'Varia Suit',
          Item(
              itemType: 'Varia Suit',
              itemId: 1,
              location: lOTGP1[4],
              checked: false));
      Hive.box('Prime').put(
          'Boost Ball',
          Item(
              itemType: 'Boost Ball',
              itemId: 1,
              location: lOTGP1[5],
              checked: false));
      Hive.box('Prime').put(
          'Space Jump Boots',
          Item(
              itemType: 'Space Jump Boots',
              itemId: 1,
              location: lOTGP1[6],
              checked: false));
      Hive.box('Prime').put(
          'Wave Beam',
          Item(
              itemType: 'Wave Beam',
              itemId: 1,
              location: lOTGP1[7],
              checked: false));
      Hive.box('Prime').put(
          'Super Missile',
          Item(
              itemType: 'Super Missile',
              itemId: 1,
              location: lOTGP1[8],
              checked: false));
      Hive.box('Prime').put(
          'Thermal Visor',
          Item(
              itemType: 'Thermal Visor',
              itemId: 1,
              location: lOTGP1[9],
              checked: false));
      Hive.box('Prime').put(
          'Spider Ball',
          Item(
              itemType: 'Spider Ball',
              itemId: 1,
              location: lOTGP1[10],
              checked: false));
      Hive.box('Prime').put(
          'Ice Beam',
          Item(
              itemType: 'Ice Beam',
              itemId: 1,
              location: lOTGP1[11],
              checked: false));
      Hive.box('Prime').put(
          'Gravity Suit',
          Item(
              itemType: 'Gravity Suit',
              itemId: 1,
              location: lOTGP1[12],
              checked: false));
      Hive.box('Prime').put(
          'Power Bomb',
          Item(
              itemType: 'Power Bomb',
              itemId: 1,
              location: lOTGP1[13],
              checked: false));
      Hive.box('Prime').put(
          'Grapple Beam',
          Item(
              itemType: 'Grapple Beam',
              itemId: 1,
              location: lOTGP1[14],
              checked: false));
      Hive.box('Prime').put(
          'X-Ray Visor',
          Item(
              itemType: 'X-Ray Visor',
              itemId: 1,
              location: lOTGP1[15],
              checked: false));
      Hive.box('Prime').put(
          'Wavebuster',
          Item(
              itemType: 'Wavebuster',
              itemId: 1,
              location: lOTGP1[16],
              checked: false));
      Hive.box('Prime').put(
          'Ice Spreader',
          Item(
              itemType: 'Ice Spreader',
              itemId: 1,
              location: lOTGP1[17],
              checked: false));
      Hive.box('Prime').put(
          'Plasma Beam',
          Item(
              itemType: 'Plasma Beam',
              itemId: 1,
              location: lOTGP1[18],
              checked: false));
      Hive.box('Prime').put(
          'Flamethrower',
          Item(
              itemType: 'Flamethrower',
              itemId: 1,
              location: lOTGP1[19],
              checked: false));
      Hive.box('Prime').put(
          'Phazon Suit',
          Item(
              itemType: 'Phazon Suit',
              itemId: 1,
              location: lOTGP1[20],
              checked: false));
      Hive.box('Prime').put(
          'Phazon Beam',
          Item(
              itemType: 'Phazon Beam',
              itemId: 1,
              location: lOTGP1[21],
              checked: false));
    }
    if (Hive.box('Prime2').isEmpty) {
      List<String> lMP2 = [
        '(Transport to Agon Wastes) Hidden behind a Splinter web near the elevator. Blow it up.',
        '(Hive Chamber A) After returning the energy to the Agon Temple, return to Temple Grounds and drop through the shaft that you descended at the start of the game. Defeat the Dark Missile Trooper in this room.',
        '(Hive Chamber B) Right past where the first Dark Portal you encountered use to be is a sealed tunnel, use a bomb to crack open the cover plate.',
        '{Sky Temple Grounds} (Plain of Dark Worship) Energize the purple crystal on the column in the corner of the Temple Assembly Site to reveal a Dark Portal, and find this within an Ingworm tower on the west side.',
        '(Temple Assembly Site) Once you have the Space Jump Boots, climb atop the cliffside on the west end, then roll through the tunnel at the end.',
        '(Communication Area) Also with the Space Jump Boots, jump atop the cliff near the entrance from the Temple Assembly Site, and bomb open the cover in the floor.',
        '(GFMC Compound) Requires the Screw Attack (easy) or Space Jump Boots (hard). Located atop the rear of the GFS Tyr. Either attempt to jump up from a crate near the damaged opening, or Space Jump from a cliff across from the nose of the ship.',
        '{Sky Temple Grounds} (War Ritual Grounds) There is a sealed door at the base of the Ingworm structure here. Use the Dark Visor and Seeker Launcher to destroy the red pods surrounding the door.',
        '{Sky Temple Grounds} (Phazon Grounds) Requires either the Dark Visor or Screw Attack. Take the portal in the Sacred Path and get to this room. Defeat the Dark Tallon Metroid here, and then cross the chasm to the tall structure ahead by use of either tool.',
        '(Transport B Access) This room is filled with Lightflyers, as well as Morph Ball tunnels on the walls. Bomb-jump your way through them.',
        '(Transport A Access) Behind the hidden Save Station here is a rock wall of Talloric Alloy. Destroy it with a bomb and move past.',
        '(Sand Cache) After visiting Agon Temple and being able to access amber holograms, scan the translator gate in Mining Station A and go into the room.',
        '(Portal Access) On one side is the remains of a Luminoth. Move around the Kinetic Orb Cannon nearby and roll into the tunnel to get behind it',
        '(Transport Center) Once you\'ve raised the gate in Dark Agon in the Portal Site, return to Light Aether and move through the gate to this room. Use the bomb slot to raise the gate, then use the halfpipe to get up to it.',
        '(Command Center) Follow the narrow tunnels on the right side of the room (below the floor on your first visit) to find this missile.',
        '(Storage B) Return to the Biostorage Station once you have the Dark Beam. Open up the black door in the corner.',
        '{Dark Agon Wastes} (Ing Cache 4) Requires the Dark Beam. Open the black door in the Duelling Range and drop to the ledge below the door you just entered.',
        '{Dark Agon Wastes} (Crossroads) Requiers the Boost Ball. Use the halfpipe in the Transport Center and go through the portal above.',
        '(Ventilation Area A) Travel to the right side of the tunnel conduit to see a Pillbug rolling around tunnels in the ceiling. Get up there and defeat it, then use double bomb-jumps in those tunnels to get to the end.',
        '(Main Reactor) Requires the Boost Ball and Spider Ball. In the corner is a Spider Ball track. Climb up and note the piston on the right above a Phazon vat. Time a boost over to it and latch onto the Spider Ball track around the top, and repeat boosting across tracks when they line up to get to the stasis chamber in the opposite corner. Use a bomb to get in.',
        '(Sand Processing) Requires the Boost Ball. Destroy the turrets, then use the halfpipe to get up to the tunnel. Roll through, activate the terminal and then the bomb slot and drop into the alcove where the sand used to be.',
        '(Storage C) Requires the Boost Ball, Super Missile, and Spider Ball. In Bioenergy Production, activate the terminal beneath the green door. Get to the northwestern corner with the three terminals, and climb up the Spider Ball track hidden nearby and boost across the structures to the center one. Boost to and follow the track east, then boost to the middle storage rack. Boost over to the green door and open it up.',
        '(Storage A) Requires a Power Bomb. In Mining Station B, destroy the cracked wall on the southern side. Go through the white door.',
        '(Mining Station A) Requires a Power Bomb and Spider Ball. Blow up the weakened wall at the base of the region, and use the Kinetic Orb Cannon to get up to the Spider Ball tracks.',
        '{Dark Agon Wastes} (Junction Site) Requires the Spider Ball. In the center you can see the missile below. Climb up the Spider Ball track and use the bomb slot at the top to rotate the structure and reveal a path to the missile.',
        '{Dark Agon Wastes} (Warrior\'s Walk) Requires the Super Missile. At the eastern end of Judgement Pit or western end of Battleground, go through the Super Missile door. In the eastern side of this room is a vein of Phazon below some floor coverings. At the foot of the door under the floor lies the missile. Use the Scan Visor to find the weakened sections and bomb them, then move quickly to avoid dying to the Phazon damage as you grab the missile.',
        '(Forgotten Bridge) Take the portal to Dark Aether and use the bomb slot to rotate the bridge. Return to Light Aether and cross it.',
        '(Hydrodynamo Station) Activate the lock below the purple door to extend a platform, then go back up and jump over to it.',
        '(Underground Tunnel) Enter via Torvus Temple, drop off the platform, and use the Morph Ball to go underneath',
        '(Plaza Access) With the Boost Ball, head here via Torvus Grove. Inside, activate the bomb slots to rotate some devices and go through the opening above. In the halfpipe, boost up to the right side.',
        '(Portal Chamber) Find the equivalent room adjacent the Venomous Pond in Dark Torvus and get to the eastern side and jump up the platforms. Roll through the opening and use the portal to find the expasion.',
        '{Dark Torvus Bog} (Undertransit One) On the leftmost part of the safe zone, use bomb jumps to find a hidden opening to some more tunnels.',
        '(Abandoned Worksite) Requires the Grapple Beam. Use the Grapple point in this room to get to the southern ledge.',
        '(Path of Roots) Requires the Grapple Beam. Enter via the Great Bridge, and use the Grapple Beam to get across to the cage.',
        '(Torvus Lagoon) Requires the Gravity Boost. In this room, defeat the Grenchlers, then go underwater and look for the Venom Weed by the wall. Use the Gravity Boost to reach an alcove there.',
        '(Gathering Hall) Requires the Spider Ball and two Power Bombs. Drop into the water in this chamber and destroy the glass with a Power Bomb. Destroy the drain cover in the base of the halfpipe with another Power Bomb. Use the now water-free halfpipe to get up to the Spider Ball tracks and energize the bomb slots on either side. This will open the path to the missile.',
        '(Training Chamber) Requires the Spider Ball. Find the track on the left of the Luminoth Statue underwater. Follow it to the bomb slot below the head, then look where the statue used to be.',
        '(Torvus Grove) Look at the roots holding up the tree with the Scan Visor and blow them up with a Power Bomb. The tree will fall and open the alcove with the missile.',
        '(Transit Tunnel South) Requires the Annihilator Beam. Go to either the Gathering Hall or Catacombs. Open the gray door to get inside. Use the bomb slots to reverse the water currents and bomb jump your way to the very top of the room.',
        '{Dark Torvus Bog} (Undertemple) Requires the Screw Attack. Return to the Undertemple where you faced the Power Bomb Guardian. Find a shaft at the north end of the chamber and use the Screw Attack to wall jump up past the light portal to the very top.',
        '(Dynamo Works) After eliminating the Spider Guardian, follow the tracks to the highest point. Find the opening in the ceiling and bomb jump through to follow that path to the end.',
        '(Hall of Combat Mastery) Requires the Spider Ball. Climb up the track up the wall past the obstacles to find the expansion.',
        '(Main Research) Requires the Spider Ball. On one side is a translucent blue wall with Spider Ball tracks. Follow the tracks without getting hit by the machinery.',
        '(Central Area Transport West) Travel to the top of this shaft and drop to the large pit below. There are three tunnels. Follow the left tunnel at the top, then the right, then the right again, then finally the left.',
        '(Temple Access) Requires the Dark Visor, Seeker Launcher, and Echo Visor. Make sure the Orb Cannon is active, and if it\'s not drop down and use the Dark Visor and destroy the red pods with the Seeker Launcher. Use the Echo Visor at the top of the room and shoot the sonic emitter. Quickly use the Orb Cannon and fall into the tunnel underneath the floor. Grab the expansion and use the Spinner to escape.',
        '(Sentinel\'s Path) Requires the Echo Visor and Annihilator Beam. Enter the corridor connecting the Sanctuary Temple and Watch Station and move to the center. Use the Echo Visor to inspect the sealed door. Shoot it with the Annihilator Beam, then shoot the four terminals in the correct tone order to open the door.',
        '(Sanctuary Map Station) Requires the Light Suit. Travel here from the Reactor Core and use the beam of light to travel to the expansion.',
        '(Hazing Cliff) Use the portal in the Hall of Combat Mastery. Exit the chamber, go right, and through the door. Defeat the enemies and cross to the other side of the chamber and defeat the drones to find a small passage.',
        '(Aerial Training Site) With the Screw Attack, use the Wall Jump surfaces near the Light Portal to grab the missile overhead.'
      ];
      List<String> lBP2 = [
        '{Sky Temple Grounds} (Profane Path) Requires the Echo Visor and Annihilator Beam. Use the Sacred Path portal and defeat the Dark Pirate Commandos. Walk over to the mutated Ingworm structure, and switch on the Echo Visor and shoot the door with the Annihilator. Fire at the tone emitters in the correct order to open it.',
        '(Central Mining Station) After retrieving the Light Beam, enter via the upper corridor of the Command Center Access. Jump into one of the turrets and destroy the various power generators in the area. After that, climb to the big red force field across from the turrets and enter the small tunnel there.',
        '{Dark Torvus Bog} (Cache A) After getting the Seeker Missiles, head to the Poisoned Bog via the Venomous Pond. Destroy the purple blast door on the south side and walk through.',
        '(Watch Station) Requires the Spider Ball. Travel up to the floating platform in the center and use the Kinetic Orb Cannon and grab onto the Spider Ball track. Be careful not to fall off on the moving sections, and move to the fork. Take the one leading to the bottom left corner, drop off, and grab the track below. Move along this track until you reach a translucent tunnel, and look for another tunnel here going north. Don\'t go right just yet, as that leads back to the ground.'
      ];
      List<String> lDP2 = [
        '{Dark Agon Wastes} (Trial Tunnel) On the first visit to the Dark Agon Temple, take the left path from the entrance to the dead-end door.',
        '{Dark Agon Wastes} (Doomed Entry) After accessing Dark Aether via the Command Center, climb up through this room with the Space Jump.',
        '{Dark Agon Wastes} (Battleground) After acquiring the Light Beam, take the western exit of Doomed Entry, follow the corridor, and defeat the Ing in this room.',
        '{Dark Torvus Bog} (Dark Torvus Arena) Acquire the Boost Ball, then boost up the halfpipe in this room.',
        '{Dark Torvus Bog} (Undertemple Access) After getting the Gravity Boost, take the portal in the Hydrodynamo Shaft.',
        '{Dark Torvus Bog} (Venomous Pond) After getting the Grapple Beam, return here and use the newly usable Grapple point at the top.',
        '(Culling Chamber) Requires the Spider Ball. Proceed down the corridor from the portal you can see this from, and use the tracks to get to the crate containing it.',
        '(Hive Gyro Chamber) Requires the Echo Visor and Spider Ball. Take the Dynamo Works portal, and go through the white door. Open the sealed door with the Echo Visor, then proceed up the Spider Ball tracks in this room.',
        '(Aerial Training Site) Get the Screw Attack, then take the portal at the Main Research room. Exit the Staging Area and Screw Attack up the walls in the following chamber.'
      ];
      List<String> lEP2 = [
        '(Storage Cavern B) Open the red blast shield with a missile in the Temple Assembly Site.',
        '(Windchamber Gateway) Requires the Light Beam, Super Missiles, and Grapple Beam. From the Path of Eyes, use the Light Beam to move the pillar blocking the Super Missile door. Behind the door, use the Kinetic Orb Cannon and Grapple Beam to get to the platform.',
        '(Fortress Transport Access) Requires the Light Suit. Step into the yellow light beam to be transported to the Energy Tank.',
        '(Mining Station Access) Destroy the bomb block covering an Orb Cannon here and use the Cannon.',
        '(Bioenergy Production) Use the terminals on the east and west side to form a staircase with the storage racks and climb up.',
        '(Mine Shaft) Requires the Dark Beam. Head to Agon Temple, open the black door. Work through the tunnels and use double bomb-jumps where needed to get up to the very top.',
        '(Mining Plaza) Requires the Echo Visor and Screw Attack. In this room are some large lenses that aren\'t lined up. Use the Echo Visor to activate the sonic emitters to line them up, then Screw Attack from the bluff to the new alcove.',
        '(Temple Access) Enter via the upper door from the Great Bridge and destroy the damaged cover plate in the corridor.',
        '{Dark Torvus Bog} (Cache B) Upon visiting the Dark Torvus Temple, roll through the red tunnel behind the western elevator, then open the Super Missile door.',
        '(Torvus Plaza) Requires the Boost Ball and Spider Ball. Use the half pipe to get to the Spider Ball track, and follow it to an Orb Cannon. Use the Cannon to get to the power-up.',
        '(Meditation Vista) Requires the Screw Attack. Travel here via the Torvus Grove, and jump to the floating platform beyond the vista where the portal is.',
        '(Transit Tunnel East) Requires the Gravity Boost. On the left side of this room, activate the bomb slot. Then, bomb jump in the second vertical current, and bomb-jump again right before you reach the apex. Use the bomb slot at the top, then bomb-jump to the top in the tube to the left.',
        '(Reactor Core) Requires the Spider Ball. Find the Orb Cannon at the base of the shaft near the reactor and be prepared to grab a Spider Ball track during the jump. Climb up to the top, and find the red node on the small sphere. Boost away from it to land on another sphere. Keep boosting away from the red nodes to reach a Spider Ball track on the wall. Be careful of all the arcing electricity.',
        '(Watch Station Access) Enter via the Watch Station and find it in an alcove.',
      ];
      List<String> lPP2 = [
        '(Dynamo Chamber) Requires two Power Bombs. In this room are two tunnels. Blow up the security gates on the lower tunnel, then blow up the weakened wall inside there.',
        '(Sandcanyon) Requires a Power Bomb and the Screw Attack. In the center lies a large statue. Screw Attack to the platform below it, and plant a Power Bomb to dislodge the statue.',
        '{Dark Agon Wastes} (Feeding Pit) Requires the Light Suit. Dive into the lake and look for the underwater alcove.',
        '{Dark Torvus Bog} (Putrid Alcove) Requires two Power Bombs. Open the yellow door in either Dark Forgotten Bridge or Poisoned Bog, and use another Power Bomb at the Denzium wall (scan visor to find it) in this room.',
        '(Great Bridge) Requires a Power Bomb. Behind the northern and eastern walls is a tunnel. Blow up a Denzium block on either side to make your way through.',
        '(Transit Station) Look for the weak glass shield protecting a portal and smash it with a Power Bomb. Defeat the enemy through the portal and proceed through the portal-hopping sequence.',
        '(Sanctuary Entrance) Requires the Spider Ball and a Power Bomb. Destroy the window left of the entrance to the fortress. Ride the lift, activate the Orb Cannon, and use it to get into a turret. Destroy the southern cliff wall, the cracked wall next to the fortress entrance, and the jagged rocks on the right hand corner of the fortress. Use the Spider Ball tracks and Orb Cannon that are revealed.',
        '(Main Gyro Station) Requires the Echo Visor and Annihilator Beam. Travel to the bottom of this room and open the sonic emitter door there, and use the Kinetic Orb Cannon within.',
      ];
      List<String> lSP2 = [
        '{Dark Agon Wastes} (Battleground) Enter via the Doomed Entry. Defeat the Ing, then turn on the Dark Visor. Jump across the platforms to the Flying Ing cache',
        '{Dark Agon Wastes} (Dark Oasis) Requires the Power Bomb and Light Suit. Inside this room is a large cracked wall. Break it with a Power Bomb, and move through the area using the Dark Visor to find the cache.',
        '{Dark Torvus Bog} (Poisoned Bog) Defeat the Hunter Ing here, drop into the lake, and use the Dark Visor to find the cache.',
        '{Dark Torvus Bog} (Dungeon) Take the portal in the Catacombs to the Dungeon. Drop into the murky water, step forward, and turn right. Shoot the Light Beacon to clear a path, and roll through the opening to the dead end. Use the Dark Visor to find the cache.',
        '(Hive Entrance) Take the portal in the Hall of Combat Mastery, then cross the Hive Reactor. Open the yellow door. In the Hive Entrance, use the Screw Attack to cross the gap, step into the light beam, Screw Attack again, then turn on the Dark Visor.',
        '(Hive Dynamo Works) Follow the tunnels from the area where you fought the Spider Guardian, and open the Power Bomb door. Go through the portal and outside, and follow the Spider Ball tracks to the cache.',
        '{Sky Temple Grounds} (Ing Reliquary) Requires the Light Suit. Take the portal in the Sacred Path, and proceed to the Reliquary Ground and through the door. Use the Dark Visor to find the cache.',
        '{Sky Temple Grounds} (Defiled Shrine) Take the portal at the Hall of Eyes and cross over to the dark equivalent of the Landing Site. Use the Dark Visor in the south-western corner.',
        '{Sky Temple Grounds} (Accursed Lake) Use the portal at the Temple Assembly Site, and pass through the purple blast shield. Defeat the Ing in the Lake, and use the Dark Visor on the far side of the lake.'
      ];
      List<String> lOTGP2 = [
        '{Temple Grounds} (GFMC Compound) Packed inside a yellow crate on the port side of the ship. Destroy it with the Charge Beam.',
        '{Agon Wastes} (Agon Temple) Defeat the Bomb Guardian.',
        '{Dark Agon Wastes} (Judgement Pit) Defeat the Jump Guardian.',
        '{Agon Wastes} (Storage D) After the first Dark Temple key and first encounter with Dark Samus, explore the Space Pirate facilities to find this room.',
        '{Dark Agon Wastes} (Ing Cache 1) Once you have the Dark Beam, you can enter the Dark world from the Command Center. Proceed to the Feeding Pit, and raise the two columns by firing the Dark Beam at the light crystals, then climb up above.',
        '{Dark Agon Wastes} (Dark Agon Temple) Defeat Amorbis after collecting three Dark Temple keys.',
        '{Torvus Bog} (Torvus Temple) Defeat the Space Pirates in the temple to remove the force field.',
        '{Dark Torvus Bog} (Dark Torvus Arena) Take the northern exit from Torvus Temple and follow the path to Torvus Grove. In the Meditation Vista beyond that, charge the portal and step in. Follow the path and defeat the Boost Guardian.',
        '{Temple Grounds} (Hall of Honored Dead) With the Boost Ball in hand, return to the Temple Grounds Meeting Grounds and boost up the half pipe and into the opening. Boost through the tunnels and enter the purple door. Align the locks using the Spinners around the room.',
        '{Torvus Bog} (Hydrochamber Storage) In the Hydrodynamo Station, activate all 3 terminals by completing the area, then go through the door at the bottom, and keep going down to the Main Hydrochamber. Go through the door on the southern side.',
        '{Dark Torvus Bog} (Sacrificial Chamber) Head to the Catacombs in Torvus Bog and open the portal using the bomb slot underwater. From there, go to the Undertemple Shaft and work your way into the Sacrificial Chamber\'s upper portion. Defeat the Grapple Guardian.',
        '{Dark Torvus Bog} (Dark Torvus Temple) Defeat the Chykka Guardian after collecting 3 more Dark Temple keys.',
        '{Sanctuary Fortress} (Dynamo Works) Defeat the Spider Guardian.',
        '{Dark Torvus Bog} (Undertemple) After grabbing the Spider Ball, dive back down to the Main Hydrochamber in Torvus. Go through the portal there, drop off the ledge, and defeat the Power Bomb guardian.',
        '{Agon Wastes} (Mining Station B) Requires Boost Ball and Seeker Launcher. Lies beyond the Mine Shaft next to Agon Temple. Break the purple blast-shield door and work your way through the following area and portal to return here for your reward.',
        '{Temple Grounds} (Grand Windchamber) Requires Boost Ball, Power Bombs, Seeker Launcher, and Grapple Beam. Head to the Path of Eyes, and move through the green blast door. Proceed through there and open the yellow blast door. Use the portal, and in there, activate the Spinners to align the rings to glow yellow, and use the Seeker missiles to break the pods. Turn the rings around to blue and repeat. Return to Aether and use the grapple points and kinetic orb cannon.',
        '{Sanctuary Fortress} (Aerie) Requires Spider Ball and Power Bombs. Return to the Main Gyro Chamber, and travel to the door leading to Sanctuary Temple. Destroy the canisters above the bomb slot by the window, and use it to power up the conduits. Line them up, then use the next slot. Use the Spider Ball track in the inner gyro. Boost yourself through the cracked glass, and open the yellow door. Defeat Dark Samus here, then head through the portal past the destroyed wall. Climb up the next Spider Ball track. Use the spinner and get up to the Light portal above. Travel through.',
        '{Sanctuary Fortress} (Vault) Travel to the Dark Portal within the Watch Station. Cross the Judgement Drop via the Grapple Points, and solve the puzzles within the Vault to open the chamber containing the Screw Attack.',
        '{Ing Hive} (Hive Temple) With all the Ing Hive Keys, open the Hive Temple and defeat Quadraxis.',
        '{Great Temple} (Main Energy Controller) Return to visit U-Mos after clearing the third temple.',
        '{Dark Agon Wastes} (Ing Cache 2) Requires the Annihilator Beam and Screw Attack. Head to the Phazon Site in the Dark Agon Wastes and defeat the Dark Tallon Metroids. Climb atop the floating platforms and Screw Attack to the ledge with the gray door.'
      ];
      for (int i = 1; i <= 49; i++) {
        Hive.box('Prime2').put(
            "Missile Expansion $i",
            Item(
                itemType: "Missile Expansion $i",
                itemId: i,
                location: lMP2[i - 1],
                checked: false));

        if (i <= 14) {
          Hive.box('Prime2').put(
              "Energy Tank $i",
              Item(
                  itemType: "Energy Tank $i",
                  itemId: i,
                  location: lEP2[i - 1],
                  checked: false));
          if (i <= 9) {
            Hive.box('Prime2').put(
                "Dark Temple Key $i",
                Item(
                    itemType: "Dark Temple Key $i",
                    itemId: i,
                    location: lDP2[i - 1],
                    checked: false));
            Hive.box('Prime2').put(
                "Sky Temple Key $i",
                Item(
                    itemType: "Sky Temple Key $i",
                    itemId: i,
                    location: lSP2[i - 1],
                    checked: false));
            if (i <= 8) {
              Hive.box('Prime2').put(
                  "Power Bombs $i",
                  Item(
                      itemType: "Power Bombs $i",
                      itemId: i,
                      location: lPP2[i - 1],
                      checked: false));

              if (i <= 4) {
                Hive.box('Prime2').put(
                    "Beam Ammo Expansion $i",
                    Item(
                        itemType: "Beam Ammo Expansion $i",
                        itemId: i,
                        location: lBP2[i - 1],
                        checked: false));
              }
            }
          }
        }
      }
      Hive.box('Prime2').put(
          "Missile Launcher",
          Item(
              itemType: "Missile Launcher",
              itemId: 1,
              location: lOTGP2[0],
              checked: false));
      Hive.box('Prime2').put(
          'Morph Ball Bomb',
          Item(
              itemType: 'Morph Ball Bomb',
              itemId: 1,
              location: lOTGP2[1],
              checked: false));
      Hive.box('Prime2').put(
          'Space Jump Boots',
          Item(
              itemType: 'Space Jump Boots',
              itemId: 1,
              location: lOTGP2[2],
              checked: false));
      Hive.box('Prime2').put(
          'Dark Beam',
          Item(
              itemType: 'Dark Beam',
              itemId: 1,
              location: lOTGP2[3],
              checked: false));
      Hive.box('Prime2').put(
          'Light Beam',
          Item(
              itemType: 'Light Beam',
              itemId: 1,
              location: lOTGP2[4],
              checked: false));
      Hive.box('Prime2').put(
          'Dark Suit',
          Item(
              itemType: 'Dark Suit',
              itemId: 1,
              location: lOTGP2[5],
              checked: false));
      Hive.box('Prime2').put(
          'Super Missile',
          Item(
              itemType: 'Super Missile',
              itemId: 1,
              location: lOTGP2[6],
              checked: false));
      Hive.box('Prime2').put(
          'Boost Ball',
          Item(
              itemType: 'Boost Ball',
              itemId: 1,
              location: lOTGP2[7],
              checked: false));
      Hive.box('Prime2').put(
          'Seeker Launcher',
          Item(
              itemType: 'Seeker Launcher',
              itemId: 1,
              location: lOTGP2[8],
              checked: false));
      Hive.box('Prime2').put(
          'Gravity Boost',
          Item(
              itemType: 'Gravity Boost',
              itemId: 1,
              location: lOTGP2[9],
              checked: false));
      Hive.box('Prime2').put(
          'Grapple Beam',
          Item(
              itemType: 'Grapple Beam',
              itemId: 1,
              location: lOTGP2[10],
              checked: false));
      Hive.box('Prime2').put(
          'Dark Visor',
          Item(
              itemType: 'Dark Visor',
              itemId: 1,
              location: lOTGP2[11],
              checked: false));
      Hive.box('Prime2').put(
          'Spider Ball',
          Item(
              itemType: 'Spider Ball',
              itemId: 1,
              location: lOTGP2[12],
              checked: false));
      Hive.box('Prime2').put(
          'Power Bomb',
          Item(
              itemType: 'Power Bomb',
              itemId: 1,
              location: lOTGP2[13],
              checked: false));
      Hive.box('Prime2').put(
          'Darkburst',
          Item(
              itemType: 'Darkburst',
              itemId: 1,
              location: lOTGP2[14],
              checked: false));
      Hive.box('Prime2').put(
          'Sunburst',
          Item(
              itemType: 'Sunburst',
              itemId: 1,
              location: lOTGP2[15],
              checked: false));
      Hive.box('Prime2').put(
          'Echo Visor',
          Item(
              itemType: 'Echo Visor',
              itemId: 1,
              location: lOTGP2[16],
              checked: false));
      Hive.box('Prime2').put(
          'Screw Attack',
          Item(
              itemType: 'Screw Attack',
              itemId: 1,
              location: lOTGP2[17],
              checked: false));
      Hive.box('Prime2').put(
          'Annihilator Beam',
          Item(
              itemType: 'Annihilator Beam',
              itemId: 1,
              location: lOTGP2[18],
              checked: false));
      Hive.box('Prime2').put(
          'Light Suit',
          Item(
              itemType: 'Light Suit',
              itemId: 1,
              location: lOTGP2[19],
              checked: false));
      Hive.box('Prime2').put(
          'Sonic Boom',
          Item(
              itemType: 'Sonic Boom',
              itemId: 1,
              location: lOTGP2[20],
              checked: false));
    }
    if (Hive.box("Prime3").isEmpty) {
      List<String> lMP3 = [
        '(Cargo Hub) Find the chute and panel in the wall near the entrance and tear the panel off with the Grapple Lasso. Roll through the chute.',
        '(Docking Hub Alpha) Requires either the Grapple Swing or Screw Attack. Find the hidden alcove behind the ship and get over the chasm.',
        '(Substation West) After getting the Plasma Beam, return to the Cargo Hold and repair the circuit panel. Enter the following chamber, and use the morph ball to enter the tunnel on the curved wall. Be careful along the pistons to avoid getting burned.',
        '(Maintenance Station) Requires the Ice Missile. Return to this room and open the white blast-shield door.',
        '(Cargo Dock A) Requires the Spider Ball. Find the track in the south-western corner and follow it.',
        '(Grand Court Path) From the entrance, climb up the narrow tunnel and find the Fuel Gel statue inside an alcove. Destroy it with a missile and climb up. Jump over the gap to another alcove on the opposite wall and follow the path, then jump to the alcove above the ice block.',
        '(Hillside Vista) Blow open a rock near the entrance and roll through the tunnels. Use the Snatchers to go up, and hold left to land in the target tunnel.',
        '(Crash Site) After activating the map station within the Federation Frigate, go outside and use the service duct you first used to enter the ship. Climb up the tunnels to land on the ship\'s wing.',
        '(Bryyo Fire - Main Lift) Enter the narrow tunnel inside and use the Snatchers to go up. Hold left, and drop a bomb as you reach the highest platform with the Korba. Follow this tunnel.',
        '(Bryyo Fire - Gel Hall) Wait for the Golem Head to rotate and face the yellow cable. Use the Charge Beam on the head then to ignite the cable with Fuel Gel and lower a platform with the expansion.',
        '(Bryyo Fire - Gel Hall) Return with the Ice Missile and stand where you found the previous missile. There\'s a tunnel leading around a corner that\'s out of sight. Use the Ice Missiles to create stepping stones in the Fuel Gel to get to that tunnel.',
        '(Bryyo Fire - Gel Refinery Site) Use Ice Missiles in the Gel Hall to create stepping stones and go through the white blast-shield door. Use the Grapple Swing in the next chamber (shooting the red switches on each point to activate them) and cross out to the Gel Refinery Site. Use the Grapple Lasso on the weakened support pipes around the corner.',
        '(Reliquary III) Requires the Ice Missile. Return to the Grand Court and use the Grapple Swing to reach a white blast-shield door.',
        '(Jungle Generator) Located right in front as you enter.',
        '(Generator Hall North) After destroying the anti-aircraft turrets and on your way back to the Jungle Generator you\'ll reach this room. Use the pump terminal to rotate the lock and reveal an alcove.',
        '(Bryyo Fire - Imperial Hall) Requires the Plasma Beam. From the Gel Refinery Site, melt the ice in the far wall. Use the tunnels in the wall, being careful of the flame vents, to reach a frozen door. Open it and head in, and swing through the Refinery Access. Use the Grapple Lasso to manipulate the two panels ahead to form a path.',
        '(Gateway) Requires the Plasma Beam. Climb up to the once sealed door and enter the tunnels inside. Melt the frozen Reptilicus ahead and use the next set of tunnels behind it.',
        '(Falls of Fire) Requires the Screw Attack. Use the Golem to reach the bottom of the huge shaft, then use the Wall Jump surfaces to get to the top.',
        '(Fuel Gel Pool) Requires the Ice Missile, Plasma Beam, and Ship Grapple. Head for the Hidden Court and go through the orange door on the north side (may require the Screw Attack to get to). Work through this region to end up in the Fuel Gel Pool. Use the Ship Grapple to remove the Golem head and freeze the Fuel Gel spouts to climb up to an alcove.',
        '(Fuel Gel Pool) Requires the Hazard Shield. Return here and dive into the oily pool and find the hidden cave on the far side under the spout.',
        '(Hidden Court) Climb up to the orange door and jump over to the halfpipe, and Boost up the right side to find an alcove.',
        '(Hall of the Golems) Requires the Grapple Voltage and Spider Ball. Leave the Hangar Bay through the orange door and end up in the Hall of the Golems. Use the Grapple Voltage to power the seal on the right side Golem and activate its bomb slot. Use the revealed Spider Ball tracks, using Boost Ball and double bomb jumps to get through complicated sections near the end.',
        '(Burrow) Use an Ice Missile in the Hall of the Golems to break the cover on the middle Golem\'s bomb slot. Activate it and climb up the frozen Fuel Gel falls and exit the chamber ahead. Enter the narrow opening and use Morph Ball bombs to destory the crystallized Fuel Gel formations, then head for the left side and double bomb jump to get up.',
        '(Ancient Courtyard) With the Boost Ball, go to the Ancient Courtyard and use the halfpipe.',
        '(Bryyo Fire - Temple of Bryyo) Requires the Hazard Shield, X-Ray Visor and Nova Beam. Look for the Phazite shield on the far side of the room and use the X-Ray Visor and Nova Beam to activate the switches on the other side. Use the Morph Ball and roll through the Fuel Gel in the opened floor section.',
        '(Transit Hub) Visible in plain sight the first time you visit this room. Use the double bomb jump to get up to it easily.',
        '(Barracks Access) Walk towards the lasers and activate the Morph Ball. When you drop down, look behind you.',
        '(Skybridge Hera) Listen for a humming sound near the entrance to the Junction area and you\'ll see an opening on a pillar nearby that sound. Crawl in with the Morph Ball.',
        '(Main Docking Bay) After defeating Ghor, climb back up to the observation windows overlooking the landing pad. Melt the damaged metal debris covering the pillar with the Plasma Beam.',
        '(Eastern Skytown - Gearworks) After receiving the Ship Grapple, return here to witness some Space Pirate destruction. Defeat them and use the Screw Attack to get up to the gears they destroyed.',
        '(Eastern Skytown - Botanica) Upon reactivating the holoprojector in the Chozo Observatory, go through the orange door above. Turn around when you get to the highest point in the room. Use the Screw Attack and you\'ll land in an alcove above the entrance.',
        '(Eastern Skytown - Concourse) After finding the Seeker Missile, you\'ll find yourself above the elevator in this room where its locking system is. Turn around and look for an opening in the wall and roll through.',
        '(Construction Bay) Requires the Screw Attack. Head for the area and climb up to the entrance leading to the Ballista Storage. Look over to the floating structure with Grapple Points underneath it. Screw Attack to the alcove with the Databot.',
        '(Powerworks) After picking up the Spider Ball, you\'ll exit by some Spider Ball tracks. As you\'re moving, you\'ll reach a platform where the tracks lead skyward to a shaft. Turn around from that and look for another track leading into a corner and follow that instead.',
        '(Steambot Barracks) Return here with the Spider Ball. Roll through the narrow tunnels at the top and use the Spider Ball tracks.',
        '(Eastern Skytown - Concourse Ventilation) Travel to the outside portion adjacent to the Chozo Observatory and use the Spider Ball to ascend the tracks in the wall.',
        '(Pirate Command - Command Courtyard) As you roll to the Energy Cell Station, you\'ll see this missile in an alcove. Roll to the opposite side of the area and follow the left path at the junction.',
        '(Pirate Command - Command Station) On your first trip here under the floors, follow the right path at the blue lift.',
        '(Pirate Command - Security Air Lock) After getting the X-Ray Visor, you\'ll enter this room from the correct side of the gate that divides the room.',
        '(Pirate Research - Scrapvault) Climb up to the very highest point using the Grab Ledge to get above the platform.',
        '(Pirate Research - Metroid Processing) Extract the Energy Cell and find this in one of the now-open Metroid holding cells.',
        '(Pirate Research - Creche Transit) Enter this area via Metroid Processing and look for a cracked covering in the corner. Destroy it with a bomb and roll through the tunnel. Use the Boost Ball to rotate the circular junction.',
        '(Pirate Research - Craneyard) Return here with the Spider Ball and follow the tracks, then use the spinners below the tall structure to create a path to the top-right of the structure.',
        '(Pirate Mines - Phazon Quarry) Use the terminal in the corner to summon the mining drill, and ask it to mine the wall on the right side.',
        '(Pirate Mines - Phazon Mine Entry) After getting the Nova Beam, exit the Main Cavern through the green door and look for the Phazite wall, then deactivate it with the X-Ray Visor and Nova Beam. Head into the room beyond.',
        '(Pirate Command - Lift Hub) Requires the Grapple Voltage. Return to the base of the Lift Hub and energize the purple terminal. Go inside the unsealed door, step inside the lift, then jump out and shoot the cable.',
        '(Pirate Command - Flux Control) With the Spider Ball, return here and travel to the base. Pull the tunnel covering over the left tunnel and roll through the right. Climb up the track.',
        '(MedLab Alpha) From the Repair Bay, head up through to the Security Access corridor, then go west to find some wreckage. Use the Grapple Lasso to clear it and enter the opening in the corner.',
        '(Auxiliary Lift) Re-establish power to the Auxiliary Lift, then look for a small opening on the east wall at the top. Go in and travel left at the base.',
        '(Weapons Cache) Use two Energy Cells in the Stairwell to get to the floor above.',
      ];
      List<String> lEP3 = [
        '{GFS Olympus} (Ventilation Shaft) Picked up in the tunnels here during the Pirate attack. Bomb the glass to get inside.',
        '(Substation East) As you enter from the Cargo Hub this Energy Tank is in the tunnel along the wall.',
        '(Reliquary II) From the Gateway, release both locks and unlock the ornate door on the west side. Travel in and clear the obstructions in the tunnels on the walls and go through the door guarded by Hoppers.',
        '(Vault) Move from the Thorn Jungle Airdock to the Overgrown Ruins. Defeat the enemies and look on the right for some crystallized Fuel Gel. Blow it up with a missile, and move through the door behind.',
        '(Ruined Shrine) Travel to the base of the Ruined Shrine beyond the Hidden Court and bomb the statue arm on the ground.',
        '(Machineworks Bridge) Enter the area from the Colossus Vista and use the Spinner to activate this half of the bridge. Cross to the center and look up. Wait for some Wall Jump surfaces to approach you and use the Screw Attack to get up.',
        '(Bryyo Ice - Tower) After finding the Spider Ball, return to the Hall of Remembrance where you found the Screw Attack. Enter the Tower and climb up the Spider Ball tracks.',
        '(Steambot Barracks) Defeat the Steamlord.',
        '(Arrival Station) After receiving the Boost Ball, use the Grab Ledge to get up the open balcony. Use the Boost Ball to activate the Kinetic Orb Cannon.',
        '(Xenoresearch A Lift) After receiving the Seeker Missile, backtrack here to find the force field blocking this upgrade removed.',
        '(Zipline Station Charlie) After getting the Spider Ball and while you\'re crossing this room, look about halfway across for a hidden circular track containing the upgrade.',
        '(Pirate Research - Scrapworks) Keep an eye out as you move through this room for the Tank at the top of the room. Reach it with a double bomb jump.',
        '(Pirate Research - Metroid Creche) Defeat the Metroid Hatcher and launch up to the tunnels in the ceiling using the Spinner. In the first tunnel, follow the Spider Ball track along the ceiling to drop into another small tunnel.',
        '(Munitions Locker) Ride up the Auxiliary Lift and move to the Port Observation Deck. On the right is a sealed door restored with an Energy Cell. Enter Junction A there and go through the eastern door.'
      ];
      List<String> lSP3 = [
        '(Auxiliary Dynamo) During your attack on the second Leviathan shield generator you might spot a narrow tunnel network wrapping around the bend. Go around the corner to find a piston stuck in place, blocking the entrance. Pull it out with the Grapple Lasso and enter the tunnel with the Morph Ball.',
        '(Bryyo Ice - Hall of Remembrance) Right after getting the Screw Attack, use it to get to the far side of the canyon. Enter the Tower, scale up, and reenter the Hall. Fire a missile into the palm of the Chozo statue, then Screw Attack to the hand, and then get on top of the Golem\'s head.',
        '(Colossus Vista) Requires the Ship Grapple. Go to the Hidden Court and climb to the orange door on the north side. Cross this area to discover the Fuel Gel Pool. Use the Ship Grapple to grab the golem head from this room. Head back towards the Hangar Bay and use the orange door to enter the Hall of the Golems. Use the Plasma Beam to reveal and activate the bomb slot on the leftmost golem. Go through the new door, and set down the Golem head onto the headless Golem.',
        '(Security Station) Requires the Plasma Beam. Travel to this room and look up above the orange door to see the item. Move to the other side of the room and melt the damaged metal debris blocking a tunnel near the massive gears with the Plasma Beam and enter the tunnel.',
        '(Hoverplat Docking Site) Requires the Spider Ball. Travel to this room and use the Screw Attack to get to the central cluster of floating pods. Use the Spider Ball tracks there and find the Ship Missile at one end.',
        '(Pirate Research - Scrapworks) With the Spider Ball, return to this room and use the halfpipe to get to the track and follow it.',
        '(Pirate Research - Processing Access) Requires the Screw Attack, X-Ray Visor and Nova Beam. Enter this room from the Scrapvault and travel halfway down. Use the X-Ray Visor and Nova Beam to activate the switches hidden behind Phazite panels. Use the Screw Attack to wall jump up, then use missiles to break the force field.',
        '(MedLab Alpha) Requires the Seeker Missiles and 2 Energy Cells. Head to the Auxiliary Lift and ride it to the top. Move to the Port Observation Deck and go to the far end, and break through the door with the Seeker Missile. It\'s located below the floor in the Xenoresearch Lab, activate the Power Station to open up access to the hatch, and watch it get taken away. Chase it down to find it in MedBay Alpha.',
      ];
      List<String> lCP3 = [
        '{GFS Valhalla} (Docking Bay 5) Find this in front of the wrecked Stiletto fighter on the right deck by the engines.',
        '{Bryyo} (Hangar Bay) Defeat the enemies during your first visit and reactivate the lift in the corner. Above, bomb the vents on the wall and one of them will take you to the alcove you need to be at.',
        '{Norion} (Generator B) You can get this after getting the Plasma Beam, but it will be easier with the Nova Beam. Go to the Cargo Hub and repair the circuit by the sealed door. Defeat the enemy within and enter the tunnels.',
        '{Bryyo} (Hidden Court) Approach the Machineworks Bridge from the Collosus Vista side, and use the Spinner to close half of the gap. After getting the Ship Grapple, fly to the Thorn Jungle Airlock and proceed to North Jungle Court. Lift the generator in this room with the ship, and go through the opening behind where it used to be. Extend the bridge in Machineworks Bridge with the Spinner, then move into the Hidden Court and set the generator on top of the Fuel Gel pump in the Command Visor.',
        '{Skytown} (Xenoresearch B) Located next to the Seeker Missile, you will discover this in Eastern Skytown after receiving the Ship Grapple. Use the Grapple Lasso to open its container.',
        '{Pirate Homeworld} (Command Courtyard) On your first trip through, avoid the acid rain and make your way up to the far corner where the ventilation fans are. Climb up and roll through the tunnels.',
        '{Pirate Homeworld} (Metroid Processing) In the Pirate Research region, you\'ll encounter this chamber. Use the X-Ray Visor to open a sealed door and ride the lift down.',
        '{Skytown} (Ballista Storage) Return to where you picked up the Boost Ball with the Grapple Voltage and overload the fans to reveal the Energy Cell station between.',
        '{Pirate Homeworld} (Phazon Quarry) After acquiring the Nova Beam, return here via Drill Shaft 2. The station is on the other side of the balcony that overlooks the quarry.'
      ];
      List<String> lOTGP3 = [
        '{GFS Olympus} (Munitions Storage) Found aboard the Olympus, scale Repair Bay A and move inside.',
        '{Norion} (Docking Hub Alpha) Found in a chamber right after landing on Norion.',
        '{GFS Olympus} (MedLab Delta) Received after Samus reawakens after the Space Pirate attack on Norion.',
        '{Bryyo} (Reliquary I) From the Gateway, open the sealed door by releasing the locks and make your way to the Grand Court. Defeat the Reptilicus Hunters and move to the Hillside Vista. Make your way to the opposite cliffside via the tunnels, then use the Grapple Lasso and a missile to destroy the statue covering the door.',
        '{Bryyo} (Bryyo Fire - Temple of Bryyo) Defeat the Rundas here to win the upgraded.',
        '{Bryyo} (Hangar Bay) After getting the Ice Missile, head to the downed Federation Frigate and head through the Falls of Fire by freezing the Fuel Gel spouts. Move through the Hidden Court and Ruined Shrine to get to the Hangar Bay. Step in and defeat the Reptilicus Hunter. Raise the Upgrade Station with the terminal, then take the lift and jump across it and activate the terminal in the command station. Drop back down, lower the upgrade station, summon your ship and raise it back up to receive the Ship Missiles.',
        '{Bryyo Seed} (Bryyo Leviathan Core) Acquired after defeating Mogenar.',
        '{Skytown} (Ballista Storage) Defeat the Defense Drone here. After discovering Ghor\'s suit on the Spire Pod, head right and continue.',
        '{Skytown} (Main Docking Bay) Defeat Ghor.',
        '{Bryyo} (Bryyo Ice - Hall of Remembrance) After getting the Plasma Beam, you will be hinted back to Bryyo. Return to the Fiery Airdock, then head to the frozen tunnel in the Main Lift. Proceed through that area and its puzzle to receive the Screw Attack.',
        '{Skytown} (Eastern Skytown - Skytown Federation Landing Site) Continue through Skytown East through the Chozo Observatory and Skybridge Athene to arrive here. Open the shutters, summon your ship, and get your upgrade.',
        '{Skytown} (Eastern Skytown - Xenoresearch B) After receiving the Ship Grapple you\'ll end up in an area filled with Space Pirate husks and Phazon Metroids. Continue to the end and use the Grapple Lasso to get access to the Energy Cell, then use it to power down the force field in the pod next to it. Break it with a missile and take the upgrade.',
        '{Elysia Seed} (Elysian Leviathan Core) Defeat Helios.',
        '{Pirate Homeworld} (Pirate Command - Command Vault) Travel to the Command Courtyard and remove the Energy Cell above the fans, then roll through the ventilation tunnels and on to the Command Vault. Destroy the orange pods above with the Seeker Missile.',
        '{Pirate Homeworld} (Pirate Research - Proving Grounds) Defeat Gandrayda. Get the map at the Lift Hub to reveal this area.',
        '{Skytown} (Powerworks) After getting the Grapple Voltage, return to Elysia Landing Bay A. Travel to the Junction, and head south. Grab the gate blocking the Zipline Access and overload it to unlock the device. Ride the zipline, and after falling, Screw Attack towards the structure beyond the drop. In the Powerworks room, stand on the raised platform and look at the cog on the floor. Pull back on it with the Grapple Lasso, then lock on and fire a missile at it while it\'s spinning. Grab the Spider Ball when it\'s revealed.',
        '{Pirate Homeworld} (Pirate Research - Craneyard) Requires the Spider Ball. Return to Pirate Research and back to the Craneyard. Use the Spider Ball track to arrive at two spinners and use them to line up a path to the top left where a tunnel away lies. Use the tunnel and move into the command room overlooking the area and use the terminal.',
        '{Pirate Homeworld} (Pirate Mines - Main Cavern) Venture to the Main Cavern via the Mining Site and activate and use the elevator on the far side. In this chamber, survive until the Phazon Mining Beam starts firing up towards the room and the Space Pirates cling onto the walls. Shoot a pirate loose into the beam, and break one of the red objects. Rinse and repeat until it\'s done.',
        '{Pirate Seed} (Pirate Homeworld Leviathan Core) Defeat Omega Ridley.'
      ];
      for (int i = 1; i <= 50; i++) {
        Hive.box('Prime3').put(
            "Missile Expansion $i",
            Item(
                itemType: "Missile Expansion $i",
                itemId: i,
                location: lMP3[i - 1],
                checked: false));

        if (i <= 14) {
          Hive.box('Prime3').put(
              "Energy Tank $i",
              Item(
                  itemType: "Energy Tank $i",
                  itemId: i,
                  location: lEP3[i - 1],
                  checked: false));
          if (i <= 9) {
            Hive.box('Prime3').put(
                'Energy Cell $i',
                Item(
                    itemType: 'Energy Cell $i',
                    itemId: i,
                    location: lCP3[i - 1],
                    checked: false));
            if (i <= 8) {
              Hive.box('Prime3').put(
                  "Ship Missiles $i",
                  Item(
                      itemType: "Ship Missiles $i",
                      itemId: i,
                      location: lSP3[i - 1],
                      checked: false));
            }
          }
        }
      }
      Hive.box('Prime3').put(
          "Missile Launcher",
          Item(
              itemType: "Missile Launcher",
              itemId: 1,
              location: lOTGP3[0],
              checked: false));
      Hive.box('Prime3').put(
          'Grapple Lasso',
          Item(
              itemType: 'Grapple Lasso',
              itemId: 1,
              location: lOTGP3[1],
              checked: false));
      Hive.box('Prime3').put(
          'Phazon Enhancement Device (PED) Suit',
          Item(
              itemType: 'Phazon Enhancement Device (PED) Suit',
              itemId: 1,
              location: lOTGP3[2],
              checked: false));
      Hive.box('Prime3').put(
          'Grapple Swing',
          Item(
              itemType: 'Grapple Swing',
              itemId: 1,
              location: lOTGP3[3],
              checked: false));
      Hive.box('Prime3').put(
          'Ice Missile',
          Item(
              itemType: 'Ice Missile',
              itemId: 1,
              location: lOTGP3[4],
              checked: false));
      Hive.box('Prime3').put(
          'Ship Missile',
          Item(
              itemType: 'Ship Missile',
              itemId: 1,
              location: lOTGP3[5],
              checked: false));
      Hive.box('Prime3').put(
          'Hyper Ball',
          Item(
              itemType: 'Hyper Ball',
              itemId: 1,
              location: lOTGP3[6],
              checked: false));
      Hive.box('Prime3').put(
          'Boost Ball',
          Item(
              itemType: 'Boost Ball',
              itemId: 1,
              location: lOTGP3[7],
              checked: false));
      Hive.box('Prime3').put(
          'Plasma Beam',
          Item(
              itemType: 'Plasma Beam',
              itemId: 1,
              location: lOTGP3[8],
              checked: false));
      Hive.box('Prime3').put(
          'Screw Attack',
          Item(
              itemType: 'Screw Attack',
              itemId: 1,
              location: lOTGP3[9],
              checked: false));
      Hive.box('Prime3').put(
          'Ship Grapple',
          Item(
              itemType: 'Ship Grapple',
              itemId: 1,
              location: lOTGP3[10],
              checked: false));
      Hive.box('Prime3').put(
          'Seeker Missile',
          Item(
              itemType: 'Seeker Missile',
              itemId: 1,
              location: lOTGP3[11],
              checked: false));
      Hive.box('Prime3').put(
          'Hyper Missile',
          Item(
              itemType: 'Hyper Missile',
              itemId: 1,
              location: lOTGP3[12],
              checked: false));
      Hive.box('Prime3').put(
          'X-Ray Visor',
          Item(
              itemType: 'X-Ray Visor',
              itemId: 1,
              location: lOTGP3[13],
              checked: false));
      Hive.box('Prime3').put(
          'Grapple Voltage',
          Item(
              itemType: 'Grapple Voltage',
              itemId: 1,
              location: lOTGP3[14],
              checked: false));
      Hive.box('Prime3').put(
          'Spider Ball',
          Item(
              itemType: 'Spider Ball',
              itemId: 1,
              location: lOTGP3[15],
              checked: false));
      Hive.box('Prime3').put(
          'Hazard Shield',
          Item(
              itemType: 'Hazard Shield',
              itemId: 1,
              location: lOTGP3[16],
              checked: false));
      Hive.box('Prime3').put(
          'Nova Beam',
          Item(
              itemType: 'Nova Beam',
              itemId: 1,
              location: lOTGP3[17],
              checked: false));
      Hive.box('Prime3').put(
          'Hyper Grapple',
          Item(
              itemType: 'Hyper Grapple',
              itemId: 1,
              location: lOTGP3[18],
              checked: false));
    }
  }
}

@HiveType(typeId: 1, adapterName: "ItemAdapter")
class Item {
  @HiveField(0)
  final String itemType;
  @HiveField(1)
  final int itemId;
  @HiveField(2)
  final String location;
  @HiveField(3)
  final bool checked;

  const Item({
    required this.itemType,
    required this.itemId,
    required this.location,
    required this.checked,
  });

  List<dynamic> fromInstance() {
    return [itemType, itemId, location, checked];
  }
}

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.url, required this.tag});
  final String url;
  final String tag;
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
          body: SafeArea(
              child: Flex(direction: Axis.vertical, children: [
        Expanded(
            child: Center(
                child: Hero(
                    tag: widget.tag,
                    child: InteractiveViewer(
                      constrained: false,
                      boundaryMargin: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 2,
                          MediaQuery.of(context).size.height,
                          MediaQuery.of(context).size.width / 2,
                          MediaQuery.of(context).size.height),
                      //clipBehavior: Clip.none,
                      maxScale: 8,
                      minScale: 0.1,
                      scaleFactor: 200.0,

                      child: CachedNetworkImage(
                          imageUrl: widget.url,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator()))),
                    ))))
      ]))),
      onTap: () => Navigator.pop(context),
    );
  }
}

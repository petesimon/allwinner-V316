# Allwinner V316 backup script

Allwinner V316 (Q6H) action camera firmware backup instructions for Linux:

1. install 'rar' and 'adb' tools if not already installed by doing the following:

1a. open a terminal window and type the command text below and press Enter key

           sudo apt-get update ; sudo apt-get install adb rar -y

2. Connect your camera to PC with a USB cable. Select 'Charging mode' and press OK.

3. open a terminal window and type the command text below and press Enter key

           chmod 755 ./backup.sh ; ./backup.sh

or         bash ./backup.sh

4. Answer whether or not you want to create a compressed archive 'backup.rar'
    of all firmware files. Please answer 'Yes' to this question.

5. Wait until done.
6. See new files in current folder and in 'backup' folder
7. rename and share your 'backup.rar' file online Goprawn forums via online cloud-storage

* Note:  the compressed archive file is RAR version 5 from http://rarlab.com

Check Allwinner V316 section in www.Goprawn.com action cam discussion forums online
and check the Facebook group http://fb.com/241278666305379 online for more.
Send me a message directly at http://fb.com/psvangorp or by email
petesimon (at) yahoo.com . Thanks for sharing.

                   ______        ____                                      
                  / ____/____   / __ \ _____ ____ _ _      __ ____         
                 / / __ / __ \ / /_/ // ___// __ `/| | /| / // __ \        
                / /_/ // /_/ // ____// /   / /_/ / | |/ |/ // / / /        
                \____/ \____//_/    /_/    \__,_/  |__/|__//_/ /_/         
             ___          __   _                  ______                   
            /   |  _____ / /_ (_)____   ____     / ____/____ _ ____ ___    
           / /| | / ___// __// // __ \ / __ \   / /    / __ `// __ `__ \   
          / ___ |/ /__ / /_ / // /_/ // / / /  / /___ / /_/ // / / / / /   
         /_/  |_|\___/ \__//_/ \____//_/ /_/   \____/ \__,_//_/ /_/ /_/    
    __  __              __            ___        __  ___            __     
   / / / /____ _ _____ / /__ _____   ( _ )      /  |/  /____   ____/ /_____
  / /_/ // __ `// ___// //_// ___/  / __ \/|   / /|_/ // __ \ / __  // ___/
 / __  // /_/ // /__ / ,<  (__  )  / /_/  <   / /  / // /_/ // /_/ /(__  ) 
/_/ /_/ \__,_/ \___//_/|_|/____/   \____/\/  /_/  /_/ \____/ \__,_//____/  

https://www.goprawn.com

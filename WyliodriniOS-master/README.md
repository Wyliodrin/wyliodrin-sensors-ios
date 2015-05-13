WyliodriniOS
============

This allows you to send messages to your boards connected to Wyliodrin. The API is still in beta.

To send messages, you need to set up two parts:
  * one on the board (via Wyliodrin)
  * one on the iOS device (via this SDK)

Semantics
---------
You cand send two types of messages:
  * open messages - messages send based on a communication_token speicfic for each board. Thsi must be specifically enabled in the Wyliodrin Web Interface. We suggest using this method for sending fast messages to a board.
  * messages - messages send based on a user communication_token and a boardid. This is enabled by default

Wyliodrin API
-------------
Create a new Python project and write

    # import wyliodrin
    from wyliodrin import *
    
    # define a function for receiving messages
    def messages(sender, label, error, message):
      print(''.join([str(temp_value) for temp_value in [label, ':<', sender, '> ', message]]))
      
    # register for messages on label 'label'
    openConnection('label', messages)

iOS API
-------

Create a new iOS project and place the filse inside the src folder into your project. This will give you access 
to the class WylioBoard. Here is are some usage exampe:

    // Send open messages
    [WylioBoard sendOpenMessageWithToken:@"..." label:@"label" message:@"..."];
    
    // send a message
    [WylioBoard sendMessageWithToken:@"..." boardid:@"..." label:@"label" message:@"..."];

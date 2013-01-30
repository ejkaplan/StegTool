Steganography is the process of hiding a message so that it doesn't look like a message is hidden. 

This tool takes text and hides it in an image by subtly altering the colors. Which pixels are meaningful, the order in which the pixels are meaningful and the cypher applied to the text are all determined by a password specific to the image, making it nearly impossible to extract the message from the image without the password. (If anybody thinks of a way to extract the message without knowing that image's password, I'd be very interested to hear it.)

ENCODING DIRECTIONS:
1) Create your message as a .txt file using your favorite text editor.
2) In the program, make sure you are in the ENCODE tab
3) Use the "LOAD_TEXT" button to load the text from your .txt file. All uppercase characters will be made lowercase and all punctuation will be removed.
4) Use the "LOAD_IMAGE" button to load an image into which you will be hiding your message. This image can be a .jpg or .png file.
5) Use the "SAVE_LOCATION" button to define where the output image will go. This output must be in .png format.
6) OPTIONAL: Define a password to be used in encrypting the image. Someone trying to extract the message from the picture will need to know this password.
7) Press the "ENCODE_MESSAGE" button to create your coded image.

DECODING DIRECTIONS:
1) Press the "LOAD_IMAGE" button and load the picture in which the secret message is hidden.
2) Type the password for that image into the "PASSWORD" box. If the password is wrong, you will either get back a garbled message or, more likely, nothing at all.
3) OPTIONAL: Press the "SAVE_LOCATION" button and define a location to save the message. The saved file must be of type .txt. If you do not save the text file, the message will still be displayed in the program.
4) Press the "DECODE_MESSAGE" button to extract the secret message.
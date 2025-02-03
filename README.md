# Bash-Script-for-Encryption-Using-the-Playfair-Cipher
Creating a Playfair cipher in Bash is more challenging compared to Python due to the lack of advanced string manipulation and data structures in Bash. 
However, it is possible to implement a simplified version. 


Explanation of the Script:


Key Table Preparation:


The prepare_key_table function creates a 5x5 table by combining the unique characters of the key and the remaining letters of the alphabet (excluding J).


Text Preparation:


The prepare_text function processes the plaintext by converting it to uppercase, removing spaces, replacing J with I, and splitting it into pairs. If a pair is incomplete, an X is added.


Encryption:


The encrypt_pair function applies the Playfair cipher rules:


If the letters are in the same row, they are replaced by the letters to their immediate right.
If the letters are in the same column, they are replaced by the letters immediately below them.
If the letters form a rectangle, they are replaced by the letters at the opposite corners.


Result:


The playfair_encrypt function combines all the steps to encrypt the plaintext using the Playfair cipher.


Example:


For the key CIPHER and plaintext EXAMPLE TEXT, the script will output the encrypted text according to the Playfair cipher rules.

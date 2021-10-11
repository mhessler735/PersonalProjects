#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#define PASS_LIMIT 255
#define BUFF_LIMIT 512

/*Function Declarations */
bool validate_Args(int args, char *file[]);
bool file_Exists(const char *filename);
void prompt_Passphrase();
bool validate_Pass(const char *passphrase);
int encrypt_decrypt(const char *input_File, const char *output_File, char passphrase[PASS_LIMIT]);
void exit_Message(const char *file);
void discard_junk();

int main(int num_Args, char *file_Names[]) { 
    char passphrase[PASS_LIMIT];
    bool valid_Passphrase = false;
    bool exit = false;
    
    int valid_Args = validate_Args(num_Args, file_Names);
    if (valid_Args == false)
        return (0);

    int file_exists = file_Exists(file_Names[1]);
    if (file_exists == false)
        return (0);

    do {
        prompt_Passphrase();
        fgets(passphrase, PASS_LIMIT, stdin);
  
    } while(!validate_Pass(passphrase));

   
    encrypt_decrypt(file_Names[1], file_Names[2], passphrase);
    exit_Message(file_Names[1]);
    return 0;
}

/*
 * Check if user entered only two arguments
 * return true if there are only two arguments otherwise return false
 */
bool validate_Args(int args, char *file[]) {
    int num_args = 0;
    if( args > 3 ) {
      printf("\nToo many arguments supplied.\n"
             "Only enter the source filepath and destination filepath\n");
        return false;
   } 
    else if(args < 3) {
        printf("Not enough arguments supplied.\n"
               "Only enter the source filepath and destination filepath\n");
        return false;
    }
    else
        return true;
}

/*
 * Check if a file exist using fopen() function
 * return true if the file exist otherwise return false
 */
bool file_Exists(const char * filename) {
    /* try to open file to read */
    FILE *file;
    if (file = fopen(filename, "r")) {
        fclose(file);
        return true;
    }
    else
        printf("\nSource File \"%s\" does not exist.\n", filename);
        return false;
}

/*
 * prompt for a valid passphrase
 */
void prompt_Passphrase() {
    printf("Enter a passphrase that meets the following requirements: \n"
           "No less than 20 characters\n"
           "Contains at least one:\n"
           "\tUppercase character\n" 
           "\tOne lowercase character\n"
           "\tOne special character\n"
           "\tOne numeric character\n");

    printf("Passphrase: ");   
}

/*
 * Check if a passphrase is 20 or more characters long,
 * and contains lowercase char, uppercase char
 * Numerical char, and special char.
 * Return true if all requirements are true, otherwise return false
 */

bool validate_Pass(const char *passphrase) {

    bool contains_Lower = false;
    bool contains_Upper = false;
    bool contains_Numeric = false;
    bool contains_Special = false;
    bool contains_20_char = ((strlen(passphrase) - 1) >= 20) ? true : false;
    bool less_than_255_char = ((strlen(passphrase) - 1) <= 255) ? true : false;

    for (const char *i = passphrase; *i != '\0'; i++) {
        if(*i >= 'a' && *i <= 'z') {
            contains_Lower = true;
        }
        else if (*i >= 'A' && *i <= 'Z') {
            contains_Upper = true;
        }
        else if(*i >= '0' && *i <= '9') {
            contains_Numeric = true;
        }
        else
            contains_Special = true;
    }
       
    if (contains_Lower == true && contains_Upper == true && contains_Numeric == true 
        && contains_Special == true && contains_20_char == true)
        return true;
    else 
        return false; 
}

/*
 * Encrypt or decrypt each character in the source file by XORing them
 * with the passphrase. Iterates through the passphrase with a pointer
 * and returns to the beginning of the passphrase once the null
 * character is reached. Buffer stores 512 chars at a time.
 */
int encrypt_decrypt(const char *input_File, const char *output_File, char passphrase[PASS_LIMIT]) {
    
    FILE *fp;
    FILE *fc;
    unsigned char buffer[BUFF_LIMIT];
    int num_Bytes;
    char *buff;
    char *pass; 

    fp = fopen(input_File, "rb");
    fc = fopen(output_File, "w");

    do
    {
        num_Bytes = fread(buffer, 1, BUFF_LIMIT, fp);
        buff = buffer;
        pass = passphrase;
        for (int i = 0; i < num_Bytes; i++)
        {
            *buff ^= *pass;
            pass++;
            buff++;
            if (*pass == '\0')
                pass = passphrase;
        }
        fwrite(buffer, 1, num_Bytes, fc);
    } while (num_Bytes == BUFF_LIMIT);

    buff = NULL;
    pass = NULL;

    fclose(fp);
    fclose(fc);

    fp = NULL;
    fc = NULL;
    return 0;

}

/*
 * Ask user if they are encrypting or decrypting. Print an exit message 
 * saying file has been encrypted or decrypted.
 */
void exit_Message(const char *file) {
    int choice;
    printf("\nEnter 1 for Encryption or 2 for Decryption: ");
    
    int i;
    do {
        int i = scanf("%d", &choice);

        if(choice == 1 && i == 1)
            printf("\n%s has been Encrypted.\n", file);
        else if(choice == 2 && i == 1)
            printf("\n%s has been Decrypted.\n", file);
        else
            printf("\nPlease enter a 1 or a 2: ");
            discard_junk();

    } while (choice != 1 && choice != 2 && i != 1);
}

/*
* Discard bad user input to prevent infinite loop
*/
void discard_junk () 
{
  char c;
  while((c = getchar()) != '\n' && c != EOF)
    ;
}
#include <stdio.h>

/*
   Justin Chen
   I pledge my honor that I have abided by the Stevens Honor System
   I chose to do selection sort
   I want to be considered for bonus points in Part 3
*/

void copy_str(char* src, char* dst)
{
    int offset = 0;

    forloop:

    // Char arrays and strings end with a null terminator
    if (*(src + offset) != '\0')
    {
        *(dst + offset) = *(src + offset);
        offset += 1;
        goto forloop;
    }

    *(dst + offset) = '\0';
}

int dot_prod(char* vec_a, char* vec_b, int length, int size_elem)
{
    /* Your code here
       Do not cast the vectors directly, such as
       int* va = (int*)vec_a;
    */

    int sum = 0;
    int index = 0;

    //Current value of vec a
    int quantA = 0;
    //Current value of vec b
    int quantB = 0;

    find_dot_product:
    //Make it not a signed char
    unsigned char singleDigitA = (unsigned char)(*(vec_a + index));
    unsigned char singleDigitB = (unsigned char)(*(vec_b + index));
    
    //Update the values of vec A and vec B
    quantA = (singleDigitA << (8 * (index % size_elem))) | quantA;
    quantB = (singleDigitB << (8 * (index % size_elem))) | quantB;

    //If we passed the length of one int, restart with new word
    if (index % size_elem == size_elem - 1)
    {
        sum += quantA * quantB;
        quantA = 0;
        quantB = 0;
    }

    index += 1;

    //Restart FOR loop as needed
    if (index < length * size_elem)
    {
        goto find_dot_product;
    }

    return sum;
}

void sort_nib(int* arr, int length)
{
    //For readability purposes (and for my sanity)
    int NIBBLE_SIZE = 4;
    int HEX_SIZE = 4;
    int BYTE_SIZE = 8;
    int INT_SIZE = 4 * BYTE_SIZE; //32
    int NIBS_IN_HEX = HEX_SIZE / NIBBLE_SIZE; 
    int MAX_NIB_IN_INT = INT_SIZE / NIBBLE_SIZE; //8
    int MAX_HEX_IN_INT = INT_SIZE / HEX_SIZE;

    //---------Step 1: Make the char array------------
    char nibs[MAX_NIB_IN_INT * length];
    int nibs_idx = 0;                   //Track which nibble index we are at right now

    //Set loop control
    int i = 0;
    int j = 0;

    char_loop:
    //We have the hex values. Now we isolate each nibble in the hex.
    if (i < length)
    {
        int curr_hex = arr[i];
        //Mask every nibble size

            j = INT_SIZE - NIBBLE_SIZE;

            inner_char_loop:
            if (j >= 0)
            {
                nibs[nibs_idx] = (curr_hex >> j) & 0xf;
                //printf("%x\n", nibs[nibs_idx]);
                nibs_idx++;

                j -= NIBBLE_SIZE;
                goto inner_char_loop;
            }
        i++;
        goto char_loop;
    }

    //Reset loop vars
    i = 0;
    j = 0;

    //------------------Step 2: Sort------------------------------
    if (length > 0)
    {
        sort_loop:
        if (i < nibs_idx)
        {
            int min = nibs[i];
            int min_idx = i;

            j = i;

            inner_sort_loop:
            if (j < nibs_idx)
            {
                if (nibs[j] < min)
                {
                    min = nibs[j];
                    min_idx = j;
                }

                j++;
                goto inner_sort_loop;
            }

            //Swap
            int temp = nibs[i];
            nibs[i] = nibs[min_idx];
            nibs[min_idx] = temp;

            i++;
            goto sort_loop;
        }
    }

    //Reset loop vars
    i = 0;
    j = 0;

    // for (int i = 0; i < nibs_idx; i++)
    // {
    //     printf("%x\n", nibs[i]);
    //     if (i % MAX_NIB_IN_INT == MAX_NIB_IN_INT - 1)
    //     {
    //         puts("---");
    //     }
    // }

    //----------------Step 3: Put it back into array--------

    nibs_idx = 0;

    compile_loop:
    if (i < length)
    {
        arr[i] = 0;
        
        j = INT_SIZE - NIBBLE_SIZE;

        inner_compile_loop:
        if (j >= 0)
        {
            char curr_nibble = nibs[nibs_idx];

            arr[i] = arr[i] | ((curr_nibble & 0xf) << j);

            nibs_idx++;

            j -= NIBBLE_SIZE;
            goto inner_compile_loop;
        }

        i++;
        goto compile_loop;
    }
}

int main(int argc, char** argv)
{

    /**
     * Task 1
     */

    char str1[] = "382 is the best!";
    char str2[100] = {0};

    copy_str(str1, str2);
    puts(str1);
    puts(str2);

    /**
     * Task 2
     */

    int vec_a[3] = {-1, 34, 10};
    int vec_b[3] = {10, 20, 30};
    int dot = dot_prod((char *)vec_a, (char *)vec_b, 3, sizeof(int));

    printf("%d\n", dot);

    /**
     * Task 3
     */

    int arr[3] = {0xBFDA09, 0x9089CDBA, 0x56788910};

    sort_nib(arr, 3);
    for (int i = 0; i < 3; i++)
    {
        printf("0x%08x ", arr[i]);
    }
    puts(" ");
    return 0;
}

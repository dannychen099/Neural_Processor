#include <iostream>
#include <vector>
#include "pe.h"

#define PE_ARRAY_WIDTH  10
#define PE_ARRAY_HEIGHT 5
#define FILTER_WIDTH    3
#define FILTER_HEIGHT   3
#define IFMAP_WIDTH     5
#define IFMAP_HEIGHT    5
#define STRIDE          1
#define OFMAP_WIDTH     (IFMAP_WIDTH - FILTER_WIDTH + STRIDE)/STRIDE
#define OFMAP_HEIGHT    (IFMAP_HEIGHT - FILTER_HEIGHT + STRIDE)/STRIDE
#define IFMAP_CHANNELS  2
#define FILTER_CHANNELS 2
#define OFMAP_CHANNELS  FILTER_CHANNELS

using namespace std;

// Local memory banks
double filter[FILTER_CHANNELS][FILTER_WIDTH][FILTER_HEIGHT] = {
    {   {0, 1, 2},          // Filter channel 1
        {1, 2, 3},
        {2, 3, 4}
    },
    {
        {1, 2, 3},          // Filter channel 2
        {2, 3, 4},
        {3, 4, 5}
    }
};
double ifmap[IFMAP_CHANNELS][IFMAP_WIDTH][IFMAP_HEIGHT] = {
    {   {0, 1, 2, 3, 4},    // ifmap channel 1
        {1, 2, 3, 4, 5},
        {2, 3, 4, 5, 6},
        {3, 4, 5, 6, 7},
        {4, 5, 6, 7, 8}
    },
    {   {1, 2, 3, 4, 5},    // ifmap channel 2
        {2, 3, 4, 5, 6},
        {3, 4, 5, 6, 7},
        {4, 5, 6, 7, 8},
        {5, 6, 7, 8, 9}
    }
};
double ofmap[OFMAP_CHANNELS][OFMAP_WIDTH][OFMAP_HEIGHT];
double zero = 0;

typedef vector<PE_unit> PE_1D;
typedef vector<PE_1D> PE_2D;

int main()
{
    PE_2D PE_array;
    PE_array.resize(PE_ARRAY_HEIGHT);

    //--------------------------------------------------------------------------
    //  Initialize PE array
    //--------------------------------------------------------------------------
    for (int col = 0; col < PE_ARRAY_HEIGHT; col++) {
        PE_array[col].resize(PE_ARRAY_WIDTH);
    }

    printf("PE array dimensions (height, width): (%d, %d)", PE_array.size(), PE_array[0].size());

	printf("\n----- Initialize PE_array filter, ifmap, and psum ID to zero-----\n");
    for (int pe_y = 0; pe_y < PE_ARRAY_HEIGHT; pe_y++) {
        for (int pe_x = 0; pe_x < PE_ARRAY_WIDTH; pe_x++) {
            PE_array[pe_y][pe_x].set_filter_id(&zero); 
            PE_array[pe_y][pe_x].set_ifmap_id(&zero); 
            PE_array[pe_y][pe_x].set_psum_id(&zero); 
        }
    }

    for (int filterChannel = 0; filterChannel < FILTER_CHANNELS; filterChannel++) {

        // Calculate each ofmap row
        for (int ofmapRow = 0; ofmapRow < OFMAP_HEIGHT; ofmapRow++) {

            // Reset the psums in each PE to zero
            for (int pe_y = 0; pe_y < PE_ARRAY_HEIGHT; pe_y++) {
                for (int pe_x = 0; pe_x < PE_ARRAY_WIDTH; pe_x++) {
                    PE_array[pe_y][pe_x].set_psum();
                }
            }

                // Cycle through each filter row. Going through all rows completes 
                // the sliding-window convolution.
                for (int filterRow = 0; filterRow < FILTER_HEIGHT; filterRow++) {
                        
                    //-----------------------------------------------------------------
                    //  Configure filter row
                    //-----------------------------------------------------------------
                    printf("\n----- Set PE_array Filter ID (hexadecimal addresses) -----\n");

                    // Over each PE row...
                    for (int pe_y = 0; pe_y < FILTER_WIDTH; pe_y++) {
                        // Over each PE column...
                        for (int pe_x = 0; pe_x < OFMAP_WIDTH; pe_x++) {
                            /* Set the filter ID in each PE row to the same value.
                                For filter with width N:
                                1 1 1 ... 1
                                2 2 2 ... 2
                                  .   .
                                  .    .
                                  .     .
                                N N N ... N
                                
                               Filter IDs are the same across each PE row.
                            */
                            PE_array[pe_y][pe_x].set_filter_id(&filter[filterChannel][filterRow][pe_y]);
                            printf("%X ", PE_array[pe_y][pe_x].filter_id);
                        }
                        printf("\n");
                    }

                    printf("\n----- Set and Display PE_array Filter Value -----\n");
                    for (int pe_y = 0; pe_y < PE_ARRAY_HEIGHT; pe_y++) {
                        for (int pe_x = 0; pe_x < PE_ARRAY_WIDTH; pe_x++) {
                            PE_array[pe_y][pe_x].set_filter();
                            printf("%f ", PE_array[pe_y][pe_x].filter);
                        }
                        printf("\n");
                    }

                //-----------------------------------------------------------------
                //  Configure each ifmap
                //-----------------------------------------------------------------
                printf("\n----- Load another ifmap -----\n");
                for (int ifmapChannel = 0; ifmapChannel < IFMAP_CHANNELS; ifmapChannel++) {

                    printf("\n----- Set PE_array Ifmap ID (hexadecimal addresses) -----\n");
                    // Over each PE row...
                    for (int pe_y = 0; pe_y < FILTER_WIDTH; pe_y++) {
                        // Over each PE column...
                        for (int pe_x = 0; pe_x < OFMAP_WIDTH; pe_x++) {
                            /* Share ifmap values diagonally across the PE grid
                                For filter with width N and ofmap width M:
                                1 2 3 ... M 
                                2 3 4 ... M+1
                                3 4 5 ... M+2
                                 ...
                               This is essentially a symmetric matrix
                            */
                            PE_array[pe_y][pe_x].set_ifmap_id(&ifmap[ifmapChannel][ofmapRow+filterRow][pe_y+pe_x]);
                            printf("%X ", PE_array[pe_y][pe_x].ifmap_id);
                        }
                        printf("\n");
                    }

                    printf("\n----- Set and display PE_array ifmap value -----\n");
                    for (int pe_y = 0; pe_y < PE_ARRAY_HEIGHT; pe_y++) {
                        for (int pe_x = 0; pe_x < PE_ARRAY_WIDTH; pe_x++) {
                            PE_array[pe_y][pe_x].set_ifmap();
                            printf("%f ", PE_array[pe_y][pe_x].ifmap);
                        }
                        printf("\n");
                    }


                    //-----------------------------------------------------------------
                    //  Calculate psums for filter convolution on current row
                    //-----------------------------------------------------------------
                    printf("\n----- psum %d of ofmap row %d -----\n", filterRow, ofmapRow);
                    for (int pe_y = 0; pe_y < PE_ARRAY_HEIGHT; pe_y++) {
                        for (int pe_x = 0; pe_x < PE_ARRAY_WIDTH; pe_x++) {
                            PE_array[pe_y][pe_x].single_line_mac();
                            printf("%f ", PE_array[pe_y][pe_x].psum);
                        }
                        printf("\n");
                    }
                }
            }

            printf("\n----- Accumulate psums upwards-----\n");
            for (int i = 0; i < FILTER_HEIGHT; i++) {
                for (int pe_y = PE_ARRAY_HEIGHT-1; pe_y > 0; pe_y--) {
                    for (int pe_x = 0; pe_x < PE_ARRAY_WIDTH; pe_x++) {
                        double bottom_psum = PE_array[pe_y][pe_x].psum;
                        PE_array[pe_y-1][pe_x].single_line_acc(bottom_psum);
                        PE_array[pe_y][pe_x].psum = 0;
                    }
                }
            }

            for (int j = 0; j < OFMAP_WIDTH; j++) {
                ofmap[filterChannel][ofmapRow][j] = PE_array[0][j].psum;
                printf("%f ", ofmap[filterChannel][ofmapRow][j]);
            }
        }
    }

    printf("\n----- Display final ofmap -----\n");
    for (int ofmapChannel = 0; ofmapChannel < OFMAP_CHANNELS; ofmapChannel++) {
        printf("\n----- ofmap channel %d-----\n", ofmapChannel);
        for (int i = 0; i < OFMAP_HEIGHT; i++) {
            for (int j = 0; j < OFMAP_WIDTH; j++) {
                printf("%f ", ofmap[ofmapChannel][i][j]);
            }
            printf("\n");
        }
        printf("\n");
    }
	return 0;
}

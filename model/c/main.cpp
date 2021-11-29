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
#define CHANNEL         1

using namespace std;

// Local memory banks
int filter[FILTER_WIDTH][FILTER_HEIGHT];
int ifmap[IFMAP_WIDTH][IFMAP_HEIGHT];

double filterRow[FILTER_WIDTH];
int ifmapRow[IFMAP_WIDTH];
int ofmapRow[OFMAP_WIDTH];
double zero = 0;

typedef vector<PE_unit> PE_1D;
typedef vector<PE_1D> PE_2D;

int main()
{
    PE_2D PE_array;
    PE_array.resize(PE_ARRAY_HEIGHT);

    for (int col = 0; col < PE_ARRAY_HEIGHT; col++) {
        PE_array[col].resize(PE_ARRAY_WIDTH);
    }

    printf("%d,%d", PE_array.size(), PE_array[0].size());

	printf("\n----- Set PE_array Filter ID -----\n");
    for (int pe_y = 0; pe_y < PE_ARRAY_HEIGHT; pe_y++) {
        for (int pe_x = 0; pe_x < PE_ARRAY_WIDTH; pe_x++) {
            PE_array[pe_y][pe_x].set_filter_id(&zero); 
            //printf("%X ", PE_array[pe_y][pe_x].filter_id);
        }
        //printf("\n");
    }

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
            PE_array[pe_y][pe_x].set_filter_id(&filterRow[pe_y]);
            //printf("%X ", PE_array[pe_y][pe_x].filter_id);
        }
        //printf("\n");
    }
 
    filterRow[0] = 11.0;
    filterRow[1] = 12.0;
    filterRow[2] = 13.0;

	printf("\n----- Set and Display PE_array Filter Value -----\n");
    for (int pe_y = 0; pe_y < PE_ARRAY_HEIGHT; pe_y++) {
        for (int pe_x = 0; pe_x < PE_ARRAY_WIDTH; pe_x++) {
            PE_array[pe_y][pe_x].set_filter();
            //printf("%08X ", PE_array[pe_y][pe_x].filter_id);
            printf("%f ", PE_array[pe_y][pe_x].filter);
        }
        printf("\n");
    }

	printf("\n----- Set and Display PE_array Ifmap ID -----\n");

    /*
	cout << "-----Set PE_array ifmap_id-----" << endl;
	for (int pe_y = 0; pe_y < PE_array.size(); pe_y++) {
		for (int pe_x = 0; pe_x < PE_array[0].size(); pe_x++) {
			PE_array[pe_y][pe_x].set_if_map_id( int(pe_y/FILTER_SIZE)* PE_ARRAY_ROW + (pe_y%FILTER_SIZE) + pe_x);
		}
	}

	cout << "-----Show PE_array ifmap_id-----" << endl;
	for (int pe_y = 0; pe_y < PE_array.size(); pe_y++) {
		for (int pe_x = 0; pe_x < PE_array[0].size(); pe_x++) {
			cout << PE_array[pe_y][pe_x].if_map_id << " ";
		}
		cout << endl;
	}

	cout << "-----Set PE_array ifmap_value-----" << endl;
	for (int i = 0; i < ifmap.size(); i++) {  //32
		for (int j = 0; j < ifmap[0].size(); j++) { //32
			dram_data = ifmap[i][j];
			for (int pe_y = 0; pe_y < PE_array.size(); pe_y++) {
				for (int pe_x = 0; pe_x < PE_array[0].size(); pe_x++) {
					PE_array[pe_y][pe_x].set_if_map(i, j);

				}
			}
		}
	}

	cout << "-----Show PE_array ifmap-----" << endl;
	for (int pe_y = 0; pe_y < PE_array.size(); pe_y++) {
		cout << " ---" << pe_y << "---" << endl;
		for (int pe_x = 0; pe_x < PE_array[0].size(); pe_x++) {
			PE_array[pe_y][pe_x].show_if_map();
		}
		cout << endl;
	}

	cout << "----- Ifmap array -----" << endl;
	show_Mat2D(ifmap);

	cout << "----calculation-----" << endl;
	for (int pe_y = 0; pe_y < PE_array.size(); pe_y++) {
		for (int pe_x = 0; pe_x < PE_array[0].size(); pe_x++) {
			PE_array[pe_y][pe_x].single_line_calc();
		}
		cout << endl;
	}

	cout << "----show p_sum-----" << endl;
	for (int pe_y = 0; pe_y < PE_array.size(); pe_y++) {
		for (int pe_x = 0; pe_x < PE_array[0].size(); pe_x++) {
			PE_array[pe_y][pe_x].show_psum();
		}
		cout << endl;
	}

	cout << "----ofmap_init-----" << endl;
	Mat2D ofmap;
	ofmap.resize(IFMAP_SIZE - FILTER_SIZE + 1);
	for (int i = 0; i < ofmap.size(); i++) {
		ofmap[i].resize(IFMAP_SIZE - FILTER_SIZE + 1);
		for (int j = 0; j < IFMAP_SIZE - FILTER_SIZE + 1; j++) {
			ofmap[i][j] = 0;
		}
	}

	cout << "----p_sum accumulation for ofmap-----" << endl;
	for (int i = 0; i < PE_ARRAY_ROW; i++) {
		for (int j = 0; j < PE_ARRAY_COL; j++) { // 10
			for (int k = 0; k < IFMAP_SIZE; k++) { // 30
				ofmap[int(i/FILTER_SIZE)*PE_ARRAY_COL + j][k] += PE_array[i][j].p_sum[k];
			}
		}
	}
	cout << "----show ofmap-----" << endl;
	show_Mat2D(ofmap);
    */
	return 0;
}

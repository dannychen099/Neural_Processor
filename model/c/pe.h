#include <iostream>
#include <vector>

using namespace std;

class PE_unit {
private:

public:
	double filter;
	double ifmap;
	double psum;

	double *filter_id;
	double *ifmap_id;
    double *psum_id;

	PE_unit() {
        // Initialize register files to zero at instantiation
        filter = 0;
        ifmap = 0;
        psum = 0;
	}

	void set_filter_id(double *id) {
        // Configured during PE initalization. Sets ID to listen to broadcasts.
		filter_id = id;
	}

	void set_ifmap_id(double *id) {
        // Configured during PE initalization. Sets ID to listen to broadcasts.
		ifmap_id = id;
	}

	void set_psum_id(double *id) {
        // Configured during PE initalization. Sets ID to listen to broadcasts.
		psum_id = id;
	}

	void set_filter() {
        //printf("%08X ", filter_id);
        //printf("%d ", *(filter_id));
        filter = (double) *filter_id;
	}

	void set_ifmap() {
        ifmap = (double) *ifmap_id;
	}

	void set_psum() {
        psum = *psum_id;
	}

	void single_line_mac() {
        // Perform the MAC operation, storing the result as a partial sum.
        psum = (filter * ifmap) + psum;
	}

    void single_line_acc(double value) {
        psum += value;
    }

};

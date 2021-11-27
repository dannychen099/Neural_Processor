module weight_hidden_mem(
    weight_hidden0, weight_hidden1, weight_hidden2, weight_hidden3, weight_hidden4, weight_hidden5, weight_hidden6, weight_hidden7, weight_hidden8, weight_hidden9, weight_hidden10, weight_hidden11, weight_hidden12, weight_hidden13, weight_hidden14, weight_hidden15
);
    output [495 : 0] weight_hidden0, weight_hidden1, weight_hidden2, weight_hidden3, weight_hidden4, weight_hidden5, weight_hidden6, weight_hidden7, weight_hidden8, weight_hidden9, weight_hidden10, weight_hidden11, weight_hidden12, weight_hidden13, weight_hidden14, weight_hidden15,
    weight_hidden16, weight_hidden17, weight_hidden18, weight_hidden19, weight_hidden20, weight_hidden21, weight_hidden22, weight_hidden23, weight_hidden24, weight_hidden25, weight_hidden26, weight_hidden27, weight_hidden28, weight_hidden29;
    
    assign weight_hidden0 = 496'b10010011_00100001_00100111_00001111_10110011_10101001_00001110_10010110_01000101_10111010_00011100_11010010_10100000_11010110_10011110_10001011_11011011_00000001_10010011_10001001_10010010_10010001_01010000_00000001_11011001_11010111_10100100_10001111_01011110_00101101_00100111_01001010_01011000_10001110_10100000_00011010_00010010_11010011_10001001_00010100_11000001_10110000_10100010_01001101_01010001_00100111_00011000_00001100_01100011_10101101_10101011_10101101_01000101_10000100_00000100_10000011_10010110_00001111_00110011_00101000_10010110_10110011;
    assign weight_hidden1 = 496'b10110000_10000100_00000100_00001111_10100110_10010001_00000001_10010000_00001111_10011011_10100000_10010100_10001111_00000100_00001100_00011000_00000000_00010011_10011011_00011111_10000110_11111111_10100001_10000001_10110000_00011010_00000100_10101111_10110011_11000000_00001100_00010000_00001010_10110001_10101010_10110000_00000011_10001101_00100011_00011101_00100001_00100011_00000010_00110010_00100010_00100100_00001100_00101001_00001110_00000011_10000011_10010011_00001111_00011000_00000011_00011111_00000001_00000001_10010100_10010101_00010110_10101011;
    assign weight_hidden2 = 496'b11111111_10011100_11101001_00001110_10000110_00111011_00000111_11100001_10111011_10100010_00001010_00111111_00001100_00100110_00000111_10000111_01011010_10001101_10001010_01001001_00110001_10010001_10101010_10111110_00011100_00100000_00000100_00001000_10001100_01001010_00111111_00010011_10110001_10000001_10101100_00101011_10110011_10101010_10001011_10001000_00110000_00101110_11101001_00000000_00010111_00100011_00110101_00010101_00100000_11100001_10011001_00010111_00011111_00100010_01001111_10000001_00010000_11010010_10001110_00111011_10001000_11000010;
    assign weight_hidden3 = 496'b10100110_00101111_00101111_00111100_11000100_00001101_10011001_00100111_00111111_00000010_10010011_00000000_10100110_00011001_11001110_10101001_00110110_01011000_10010001_00001111_10101100_00101000_10100001_00011101_00110000_00000101_10000001_10010100_10100000_10100111_00010001_10110101_10110001_00001001_10011000_11000101_10010101_00011001_00101101_10000011_10001101_11000011_00000110_00101011_10110101_01001011_10110001_10110101_10001011_01000000_10111100_10001111_00110000_10110100_10101010_00001100_00100001_10000101_00000111_00011011_10100100_11010001;
    assign weight_hidden4 = 496'b10100111_10111000_00100110_00010100_10001101_10100011_10100110_00010100_10011001_10101110_00110111_11111011_10010001_00000110_10110100_00000010_10010100_10011011_00011101_10000101_00010110_00110001_00010111_10100101_00000101_10011100_00001010_10010101_00110110_00011110_00000110_10100001_11111111_10001100_10101111_10011101_01101101_10010111_10001010_00111111_10000110_10010101_00011101_00000110_10101100_00010001_00000010_00000100_00110011_00010011_00001111_10011000_00000101_00110110_00010111_00001010_00010001_00011101_10001000_00001110_00001111_10011100;
    assign weight_hidden5 = 496'b10101000_10100000_10011111_10110111_00000110_10011100_10011010_10000101_10000011_10000101_00001001_10000011_00000000_00010110_10010001_00011001_11001101_00001110_00010001_00010011_00000101_10001101_10011011_00000010_00001110_00011111_10010111_10011001_10010111_10011010_10011101_00010100_00001101_00100011_00110101_10011110_10011010_01001001_00010000_00011111_10001111_00100010_00010001_00011010_00000101_00110011_10001010_00001110_00010010_10101100_00001110_10100110_00010001_10000010_00101001_10101100_00110001_10101111_11010000_00000001_00001110_00101000;
    assign weight_hidden6 = 496'b00001111_10001111_10011000_10000101_00000101_10010010_10000001_10010000_10011011_00010110_10100010_10010101_10001110_00001110_10101101_11001101_01010000_10100000_11111111_10000010_00000011_00000101_10000110_10001111_10010011_01100010_10011001_10001000_00001001_00010001_10011010_11010000_10100010_10000010_00001101_00110111_10010110_00010000_10000110_01001000_01101110_00100001_10000001_10001101_10001101_10001000_11000001_00101010_10100010_00000000_00001101_00111001_10000111_01101011_10001011_10101111_00010011_00010010_10011100_00000000_10100001_11000110;
    assign weight_hidden7 = 496'b00010110_10011100_10001100_00011100_11000110_01001100_00101101_01001101_10100010_00001110_11001001_11001100_10001111_10000110_01001000_01000001_11111111_10000111_00001111_10011000_10001001_10101011_00000110_00100110_10110101_00111001_00111010_00101101_10000011_11000011_10000101_01100011_10100111_10000001_10100110_10001111_10000011_10010111_10110000_10100101_11100100_10100000_00010100_10010010_00011101_10101110_10010000_10011111_00011010_00100000_10101110_10001101_10000110_11100100_00011001_10000011_10101101_10011010_10111001_00010011_10011110_10001010;
    assign weight_hidden8 = 496'b11011001_00011000_10101100_10011001_00011011_00101010_00000101_11010001_00110111_10010011_10010111_10111001_00001111_00011101_00111001_10101010_00001111_00001111_10000010_00001000_10010110_10110000_00001101_10101011_10001110_00000101_10010100_10010001_00000000_10001100_00100101_10001101_00100111_00101010_00010100_10001001_10001000_00100011_00001010_00010010_00111101_01101011_00100000_00110101_10000110_10001010_11001000_10110001_11000111_11001010_10100010_00010010_00001100_00010110_10100101_00000010_00000101_10100010_00010101_10001111_10010000_11010011;
    assign weight_hidden9 = 496'b10110110_10101011_10010011_10011100_10011010_11111111_00001100_10001110_10000011_00010001_11000100_01001000_10010100_11101100_01101010_11101000_11111111_00110001_11110010_00010111_10010110_11111001_00011100_10001011_11110001_10111000_10101110_00011110_00100000_00010001_00010011_01111111_01100001_01111111_01000000_00100101_11001001_10110101_11111111_10000100_10110011_01111111_11111111_10111110_00000000_00000110_01111111_00011101_10111000_00000110_10100100_01000101_10011111_00101000_10000111_00011110_01011110_00100000_10001101_00000000_00101100_01000001;
    assign weight_hidden10 = 496'b10010010_10011011_10100001_00010100_10111000_00010000_00011100_10010000_10000011_10000010_10101011_01011001_00000101_00000111_00001110_00011000_00110001_00010010_00000101_00010001_10000001_10010010_10101110_10011001_10001101_10001000_10010001_00001110_10111101_00000110_00001110_01001001_00110111_10010111_00001111_10100110_11001011_10001101_10010101_00000110_00011101_00101010_11101101_10100100_00101011_00111100_00100111_10000111_00010001_11001011_00110001_11000100_00010110_00000001_00011011_10001010_10110100_00111110_00001110_10110111_00011111_00000011;
    assign weight_hidden11 = 496'b00011011_10011110_10001000_10001110_10010001_10010011_00010010_00001100_00000000_00001000_10000111_00100011_10000100_00011111_00000001_00011000_00010110_10011101_11000000_01000010_10000011_10010000_10010000_00010110_10010011_00100110_10000010_00001100_10010010_10001101_01000001_00011111_10100000_11011001_10010110_10100111_00100111_00000010_00001000_10101111_10110110_10101101_10010011_10000101_00100001_00011011_00100111_00101110_10000100_10000010_10000010_10001001_10100010_10000011_10011010_10001011_10100000_10011101_10111000_00001000_00010101_11000101;
    assign weight_hidden12 = 496'b10010011_10011100_10010100_00000010_00000010_00111101_00101000_00111111_00011000_10000110_00011100_00010111_10111011_00010100_10001000_00110111_00101000_10010000_01010010_00101001_00101011_10111100_10101011_00000000_00001111_10011010_00011111_00100101_00001011_10010010_00100001_11010110_10010111_10010101_00000101_00111000_00010011_00000001_00110110_00011001_00011000_10001001_11000111_10010110_10111100_11011001_10010111_10011100_10100100_00010011_10101010_10011000_10101000_10101001_10100101_10000101_10101001_00010010_10000101_00100100_10000001_00010100;
    assign weight_hidden13 = 496'b00011001_10001010_10000010_10011001_00001011_10000110_00001100_00011100_10001001_00011000_10001010_00000110_10101100_00100001_01000010_10011101_10110010_00000100_00000000_00110011_10100010_00100010_10101101_00010000_10000001_10011011_10001011_00001001_10001001_00011000_10001010_00000101_00001001_10100000_00001100_00010010_00000011_00011110_00010101_10001111_10100000_10111101_10100010_00001010_00000111_00010100_00100011_00100011_10001101_00000100_00001001_00010010_10100011_00000010_10010101_10011000_00000111_00000000_00010001_10100011_00011001_00100000;
    assign weight_hidden14 = 496'b00100001_10100010_10000011_10001000_00000000_00000101_00001000_10000100_10111100_10000011_10011100_00110111_00101011_00011110_00001101_10111001_11011000_00001010_11001011_10001001_10010011_10100101_00111000_10001000_10110011_01100010_00001000_00010100_00011001_10001101_10001010_10010101_11110010_01010010_00000011_00010011_00100001_00100001_10100000_00101001_10000011_00110001_01011110_00011001_10101001_10101110_10011000_00011100_00000011_00000001_10001111_10000001_00100101_11011001_00001101_10011100_00010010_10001110_00010011_10000001_00100001_00010010;
    assign weight_hidden15 = 496'b00110110_00011000_10001001_00100100_01100000_00110001_10001111_10010100_10101001_00011010_00100110_10100000_10000111_10100010_10111100_11010101_11111001_11011101_00110010_00010010_10001011_00010010_10100110_00000010_10101011_00011011_00000100_10100110_10001010_10000110_10001011_10010011_10000101_10000001_10101100_00110000_11011101_10100011_11001011_10101000_10010100_10101000_11001101_10101100_00101011_00101111_00110110_10000100_10001000_10100110_00001011_10100010_10011001_10011111_00000111_00010100_10111101_00001011_00011111_00011010_11111000_00101001;
    assign weight_hidden16 = 496'b00011010_00000000_00100010_00101010_00001000_01100011_00011010_00011111_10011010_10001010_10001110_11000101_11010110_10011110_10011010_00010110_00100101_10011101_10110100_00100110_00000101_10000010_10100000_00010010_10110101_00000111_11000000_10111100_00000011_10110010_00000101_10010001_11000110_10000011_10110101_10010100_00011110_10011001_00001010_00110111_10001000_10010110_10011101_00001000_00101111_00000011_10010000_00000110_00010110_10000011_00001000_00000100_00110110_00100011_00010011_10010111_00000111_10000001_10001111_00100111_11101010_00001001;
    assign weight_hidden17 = 496'b00000000_10000001_00000000_10011011_00001110_10110100_10011111_10110001_10001000_00010001_11011000_00000111_00001110_00010001_10010000_10100101_10010001_00000000_10101011_10011111_10011011_10000010_00011110_10000100_00001010_10001110_00000110_00011111_00010000_10010111_00001010_00001101_00110011_00001101_00000001_00010111_00001111_00101011_00000000_10000001_00000100_00001100_10111001_00111101_10101011_00001110_10000111_00010001_10010111_11011101_00100000_00011011_10001111_00011001_00100111_11100010_00000010_00010111_10000111_00100111_10111001_10010000;
    assign weight_hidden18 = 496'b00010101_10000001_00001111_10001100_00101000_10100010_10100110_10010001_00010001_00110001_11010110_00010011_10000100_10111011_10001000_10001010_00010101_00100110_00001000_10001111_10001010_10101110_00011111_10101010_00111011_10110010_10100111_10001010_10011011_10010111_00111111_10001001_10010100_00001001_10001000_00010100_10000111_11011110_00010001_10011000_10000001_00001100_00101101_10011000_00001111_10101010_10111010_10001111_00010000_00000101_00100000_11001011_00110000_00011000_10100000_10010101_10011101_00111011_10011001_01001110_00101101_10011000;
    assign weight_hidden19 = 496'b00111110_11010110_00010100_10001000_10011110_10010000_00110110_00110000_10110001_00011110_00001000_00101110_10001010_10101000_10011001_00000001_00001010_00101111_10110101_11000111_00010011_10010101_10000111_00100000_10110101_10000011_00000011_00001000_00001100_10010100_10100110_00111110_10111001_00111001_10011101_10100111_10100001_10001100_11001101_00011111_10000111_01101010_10101011_10100111_10100100_10000011_10000001_00011001_10010001_00101101_00001001_00100101_00011010_10010001_10000100_10011000_00110111_00010101_00000101_10000100_00011101_00101010;
    assign weight_hidden20 = 496'b10001000_10000011_10001101_10011001_00001111_00010001_00000001_00000111_00001111_00001001_10100001_10110111_10011100_00001100_00000111_00000010_00001110_10011100_00101100_01000100_00100010_00000010_10010000_00000111_10010011_01001010_10000101_00011010_10000101_00000110_00000000_00100100_10001101_00011000_00001001_10010011_00000001_00001000_00000011_10100010_10011100_00100101_10001101_10011011_00011111_10011100_00001111_10010011_10011111_00000011_11010011_00000100_10000101_10100011_10010111_00100101_11000010_10011101_10011010_00110000_00011001_11110010;
    assign weight_hidden21 = 496'b10010111_00011101_10100011_00001000_00010001_10000110_10001000_10001111_00101101_00100110_10010000_00010111_00110101_00000100_10010110_00000011_00110111_10101000_00111000_10111001_00010010_00000011_00011011_01001000_00101011_10001101_00100001_00100001_10011110_00011101_11011101_01010110_00110100_10010111_00011011_10001001_10100010_10000001_11000100_00010111_00011000_00101110_00100000_11001110_01100101_10010001_00010110_01001100_00011010_10011100_10010011_00000010_00000000_10010100_00001100_00101110_10111110_10110011_00010011_00111011_11000001_11011100;
    assign weight_hidden22 = 496'b10011010_10010110_10000001_10011010_00011000_10000001_10001100_10010000_00000011_10011000_00111111_10000110_00000110_00001010_10001001_10010110_00001001_00000011_01000111_10001000_10000101_10010001_00001001_00010110_00110101_11000101_10001000_10001000_00000101_00010000_00011011_10000110_00101111_10000101_10101000_00001101_00011111_10000010_10001001_00001000_00100010_10110011_10100001_00000000_00000000_00001101_10000100_00000000_00000011_10001010_00000011_10001010_11001010_00001111_10000001_10001001_00010100_10000111_00010100_00100000_00001100_10011100;
    assign weight_hidden23 = 496'b10100111_01000110_10101011_00001111_10100111_00001100_10011100_10100100_00101010_00000000_00001110_10100101_00001000_10001100_10001101_11000101_10010011_10000101_00011101_00010101_10000010_00001010_00100111_00000010_10011011_00100111_10001110_00010101_10101010_00100101_10110010_00100010_00001010_00111111_00011100_00000100_00000111_00011001_10101010_10111100_10101011_10110010_10100001_00001110_10010001_00100000_11011111_10101100_10100010_10101110_00000001_00100010_10000110_00111000_00101001_00011000_00000010_00011010_10001010_00111011_10011010_00001111;
    assign weight_hidden24 = 496'b00001110_10100000_10011111_00111000_00001001_10000110_10111001_00100100_10000010_10001111_00001010_10100010_00101111_01111111_11010111_00111111_10100110_10010010_10011011_00000101_10101111_01000000_10010110_00100100_11001001_01110111_00000101_00100000_10000011_10011000_10010100_00000100_00101010_10011000_11001111_11001101_10110101_10101001_11101111_10011010_00001010_00100111_00100100_00100100_00110000_01111111_00010111_00000111_10011011_10011000_00001000_10011001_00000010_11010000_00110001_10001000_00010101_10110000_00001111_10011111_10001010_00100000;
    assign weight_hidden25 = 496'b10000100_11011110_10010110_00100000_00011101_10001100_00000111_10010010_11000110_00101110_10010001_00100010_00001100_10101101_10101000_00000011_11000011_00100000_10011000_10001000_00000100_10100101_00001001_10100010_00010101_00000110_00100100_00010100_10010111_00000110_01010100_11000100_10110011_00111111_10001000_00110111_10101100_10011010_10001101_00010110_00001000_00110111_00011010_10010000_01000010_00100111_00100010_00011100_10110000_10110001_00011001_10110011_00010110_11011100_10010110_10010001_00000000_10001110_00101001_00011111_10100000_00110001;
    assign weight_hidden26 = 496'b00001000_00010110_10011000_10010011_10010111_11001011_00000111_10011100_00111011_00000111_10100000_00110000_00100111_10011100_00001000_00001000_00100110_00010000_10101101_10101000_00001010_10000001_00011001_10001111_00011110_10100101_10000001_10100000_10011100_10001011_10001010_00010100_00000001_10001010_10000100_10111001_10111100_10110011_10011111_10000011_00011110_00110101_00100100_10110100_10010011_10101111_10000001_00011010_00011111_00011111_10000101_00001110_10001010_00101001_10011110_10000001_00000011_00001001_00101000_00001000_10001000_10010011;
    assign weight_hidden27 = 496'b10010011_00011100_01000000_00000011_00001000_00110000_00010101_10010011_11001001_00110111_10010010_00011010_10110111_10111010_00011000_10000111_10010011_10011001_00000000_10110000_00100000_10010011_10100001_10111001_10011001_00000001_01100011_10000011_00000110_11010111_10011000_00000011_00000001_10110111_10001001_10001111_11101110_00011011_10001111_10101101_00010001_00010111_10001000_00111101_10111010_10100010_00101101_10000111_10000100_00001011_00111101_01000000_10000111_10011011_00110111_10100010_10001100_00011111_00000101_10000100_10010101_10001010;
    assign weight_hidden28 = 496'b10000100_10001010_10000010_10000111_00001100_10011010_10011001_10001110_10011110_10010001_10100100_11000000_10001001_10010000_10000001_00000100_00000011_10100101_00011001_00000110_00001001_00000010_10001111_00000000_10000100_10001000_00010011_00010100_10000011_10000100_10010000_00000100_00001010_00010001_00011110_10000010_10010000_00011001_00010001_10001010_00000100_00010001_10001001_00001100_00000011_00000010_00000110_00000000_10001111_00000101_10001011_00000001_00010110_10001101_10001010_00010000_10010000_00010111_10011110_10101101_10001000_11000010;
    assign weight_hidden29 = 496'b10100010_00011011_00001010_10010010_00000100_00001100_00001000_10010000_00110110_10011100_00000001_10101111_00110011_10001001_00011110_01001111_00111110_10011111_00000000_10010011_00001000_00000101_00011010_00011000_10110000_10100110_00000111_00001011_00101011_00001101_10000111_00001001_00101100_00100111_10010001_00100010_10010011_10001011_00000101_11001011_10010110_00001100_00001001_00000111_10101001_10100010_10110111_10010111_10100011_10100111_10011011_00010100_10011011_10001100_10011100_10001010_10010100_10011100_10011001_10110011_00000010_10001000;

endmodule
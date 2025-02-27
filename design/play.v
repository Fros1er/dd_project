module play (input [1:0]game_status,
                       input clk_d,
                       rst,
                       input[3:0]act,
					   input random,
						input set,
						input[4:0] num,
                       output reg [11:0]out_game,
                       output reg win_flag);

localparam CHOSE_BOARD  = 2'b00;
localparam GAMING       = 2'b01;
localparam GAME_INITIAL = 2'b10;
localparam WINNED       = 2'b11;

//black_position
localparam LEFT_UP    = 2'b00;
localparam LEFT_DOWN  = 2'b10;
localparam RIGHT_UP   = 2'b01;
localparam RIGHT_DOWN = 2'b11;

reg[11:0]out;
reg [1:0]black_pos;
reg [2:0]save;
wire[11:0]rand_gen;
random rd(clk_d,rst,rand_gen);
initial begin
    black_pos <= LEFT_DOWN;
    out       <= 12'b000_001_010_011;
    win_flag  <= 1'b0;
end

always @(posedge clk_d,posedge rst) begin
    if (rst)begin
        black_pos <= LEFT_DOWN;
        out       <= 12'b000_001_010_011;
    end
    else  begin
        case(game_status)
            CHOSE_BOARD:begin
			if (set&~random)begin
            case(num)
                5'b00000:out <= 12'b000_001_011_010; //0132
                5'b00001:out <= 12'b000_010_011_001; //0231
                5'b00010:out <= 12'b001_000_011_010; //1032
                5'b00011:out <= 12'b001_010_011_000; //1230
                
                5'b00100:out <= 12'b010_000_011_001; //2031
                5'b00101:out <= 12'b010_001_011_000; //2130
                // ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  = 
                5'b00110:out <= 12'b000_001_010_011; //0123
                5'b00111:out <= 12'b000_011_010_001; //0321
                
                5'b01000:out <= 12'b001_000_010_011; //1023
                5'b01001:out <= 12'b001_011_010_000; //1320
                5'b01010:out <= 12'b011_000_010_001; //3021
                5'b01011:out <= 12'b011_001_010_000; //3120
                
                // ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  = 
                5'b01100:out <= 12'b000_010_001_011; //0213
                5'b01101:out <= 12'b000_011_001_010; //0312
                5'b01110:out <= 12'b010_000_001_011; //2013
                5'b01111:out <= 12'b010_011_001_000; //2310
                
                5'b10000:out <= 12'b011_000_001_010; //3012
                5'b10001:out <= 12'b011_010_001_000; //3210
                // ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  = 
                5'b10010:out <= 12'b001_010_000_011; //1203
                5'b10011:out <= 12'b001_011_000_010; //1302
                
                5'b10100:out <= 12'b010_001_000_011; //2103
                5'b10101:out <= 12'b010_011_000_001; //2301
                5'b10110:out <= 12'b011_001_000_010; //3102
                5'b10111:out <= 12'b011_010_000_001; //3201
                
                // ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  = 
                default:out <= out;
                endcase
			end
			else if (set&random)  begin
				out <= rand_gen;
			end
			else begin
				out<=out;
				end
				end
            GAME_INITIAL:begin
                // out    <= {origin_bd[11:6],3'b100,origin_bd[2:0]};
//                out[5:3]  <= 3'b100;
                black_pos <= LEFT_DOWN;
            end
            GAMING:begin
                case(black_pos)
                    LEFT_UP:begin
                        if (act[1])begin
                            out       <= {out[8:6],out[11:9],out[5:0]};
                            black_pos <= RIGHT_UP;
                        end
                        else if (act[2])begin
                            out       <= {out[5:3],out[8:6],out[11:9],out[2:0]};
                            black_pos <= LEFT_DOWN;
                        end
                        else begin
                            out       <= out;
                            black_pos <= black_pos;
                        end
                    end
                    
                    RIGHT_UP:begin
                        if (act[3])begin
                            out       <= {out[8:6],out[11:9],out[5:0]};
                            black_pos <= LEFT_UP;
                        end
                        else if (act[2])begin
                            out       <= {out[11:9],out[2:0],out[5:3],out[8:6]};
                            black_pos <= RIGHT_DOWN;
                        end
                        else begin
                            out       <= out;
                            black_pos <= black_pos;
                        end
                    end
                    
                    LEFT_DOWN:begin
                        if (act[0])begin
                            out       <= {out[5:3],out[8:6],out[11:9],out[2:0]};
                            black_pos <= LEFT_UP;
                        end
                        else if (act[1]) begin
                            out       <= {out[11:6],out[2:0],out[5:3]};
                            black_pos <= RIGHT_DOWN;
                        end
                        else begin
                            out       <= out;
                            black_pos <= black_pos;
                        end
                    end
                    
                    RIGHT_DOWN:begin
                        if (act[0])begin
                            out       <= {out[11:9],out[2:0],out[5:3],out[8:6]};
                            black_pos <= RIGHT_UP;
                        end
                        else if (act[3])begin
                            out       <= {out[11:6],out[2:0],out[5:3]};
                            black_pos <= LEFT_DOWN;
                        end
                        else begin
                            out       <= out;
                            black_pos <= black_pos;
                        end
                    end
                    
                    default:begin
                        out       <= out;
                        black_pos <= black_pos;
                    end
                endcase
            end
            WINNED:begin
                black_pos <= black_pos;
                out       <= out;
            end
            default:begin
                black_pos <= black_pos;
                out       <= out;
            end
        endcase
    end
end
always @(posedge clk_d) begin
    case(out_game)
        12'b100_001_010_011:win_flag <= 1'b1;
        12'b000_100_010_011:win_flag <= 1'b1;
        12'b000_001_100_011:win_flag <= 1'b1;
        12'b000_001_010_100:win_flag <= 1'b1;
        default:            win_flag <= 1'b0;
    endcase
end
always @(posedge clk_d,posedge rst) begin
    if(rst)out_game<=12'b000_001_010_011;
    else begin
        if(game_status==GAME_INITIAL|game_status==GAMING)begin
            case(black_pos)
            LEFT_UP:out_game<={3'b100,(out[8:0])};
            LEFT_DOWN:out_game<={(out[11:6]),3'b100,(out[2:0])};
            RIGHT_DOWN:out_game<={(out[11:3]),3'b100};
            RIGHT_UP:out_game<={(out[11:9]),3'b100,(out[5:0])};
            default:out_game<=out_game;
            endcase
        end
        else
        out_game<=out;
    end
end
endmodule

module random (
    input clk_d,rst,
    output reg[11:0]rand_out
    );
    
    reg[4:0] regi;
    
    always @(posedge clk_d,posedge rst) begin
        if (rst)
            regi <= 0;
        else if (regi>=5'b11000)
            regi <= 0;
        else
            regi <= regi+1'b1;
    end
    
    always @(posedge clk_d,posedge rst) begin
        if (rst)
            rand_out <= 12'b000_001_010_011;
        else begin
            case(regi)
                5'b00000:rand_out <= 12'b000_001_011_010; //0132
                5'b00001:rand_out <= 12'b000_010_011_001; //0231
                5'b00010:rand_out <= 12'b001_000_011_010; //1032
                5'b00011:rand_out <= 12'b001_010_011_000; //1230
                
                5'b00100:rand_out <= 12'b010_000_011_001; //2031
                5'b00101:rand_out <= 12'b010_001_011_000; //2130
                // ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  = 
                5'b00110:rand_out <= 12'b000_001_010_011; //0123
                5'b00111:rand_out <= 12'b000_011_010_001; //0321
                
                5'b01000:rand_out <= 12'b001_000_010_011; //1023
                5'b01001:rand_out <= 12'b001_011_010_000; //1320
                5'b01010:rand_out <= 12'b011_000_010_001; //3021
                5'b01011:rand_out <= 12'b011_001_010_000; //3120
                
                // ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  = 
                5'b01100:rand_out <= 12'b000_010_001_011; //0213
                5'b01101:rand_out <= 12'b000_011_001_010; //0312
                5'b01110:rand_out <= 12'b010_000_001_011; //2013
                5'b01111:rand_out <= 12'b010_011_001_000; //2310
                
                5'b10000:rand_out <= 12'b011_000_001_010; //3012
                5'b10001:rand_out <= 12'b011_010_001_000; //3210
                // ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  = 
                5'b10010:rand_out <= 12'b001_010_000_011; //1203
                5'b10011:rand_out <= 12'b001_011_000_010; //1302
                
                5'b10100:rand_out <= 12'b010_001_000_011; //2103
                5'b10101:rand_out <= 12'b010_011_000_001; //2301
                5'b10110:rand_out <= 12'b011_001_000_010; //3102
                5'b10111:rand_out <= 12'b011_010_000_001; //3201
                
                // ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  = 
                default:rand_out <= rand_out;
            endcase
        end
    end
endmodule

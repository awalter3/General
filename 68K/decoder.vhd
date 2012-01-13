LIBRARY ieee;
USE ieee.std_logic_1164.all;


entity sek_decoder is
	port( as,lds,rw               : in std_logic;
		  a,b,c			          : in std_logic;
		  rom_cs                  : out std_logic;
		  ram_cs                  : out std_logic;
		  dip_cs                  : out std_logic;
		  led_cs                  : out std_logic;
		  dac_cs                  : out std_logic;
		  adc_cs                  : out std_logic;
		  pic_cs                  : out std_logic;
		  dtack                   : out std_logic;
		  wr   		              : out std_logic
		 );
end sek_decoder;


architecture dec_arc of sek_decoder is
	signal abc : std_logic_vector(2 downto 0);
	signal result : std_logic_vector(7 downto 0);
	signal en     : std_logic;

	begin
		en<=(not(as))and(not(lds));
		abc<= a&b&c;
		process(abc,en,result,rw)
		begin
			if(en = '1')
				then
					case abc is
						when "000"=>result<="00000001";		
						when "001"=>result<="00000010";
						when "010"=>result<="00000100";
						when "011"=>result<="00001000";
						when "100"=>result<="00010000";
						when "101"=>result<="00100000";
						when "110"=>result<="01000000";
						when others=>result<="00000000";
					end case;
				else
					result<="00000000";
			end if;
			rom_cs<= not(result(0));
			ram_cs<= not(result(1));
			dip_cs<= not((result(2) and rw));
			led_cs<= (result(3)and(not(rw)));
			dac_cs<= not(result(4));
			adc_cs<= not(result(5));
			pic_cs<= result(6);
			dtack<= not(en);
			wr<=not(rw);
		end process;
end dec_arc;
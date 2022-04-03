     
       
 -- All the signals and variables were explained in details in the report


        --Basic Gates
------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
entity and2  is
	port( a,b:in std_logic;
	c: out std_logic);
end entity and2;
										   -- 2 inputs and gate
architecture arc of and2 is
begin
	c<= (a) and (b) after 8 ns;
end architecture arc;
------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
entity or2  is
	port( a,b:in std_logic;
	c: out std_logic);
end entity or2;								  -- 2 inputs or gate

architecture arc of or2 is
begin
	c<= (a) or (b) after 8 ns;
end architecture arc;
------------------------------------ 
library ieee;
use ieee.std_logic_1164.all; 
entity xor2  is
	port( a,b:in std_logic;
	c: out std_logic);						 -- 2 inputs xor gate
end entity xor2;

architecture arc of xor2 is
begin
	c<= (a) xor (b) after 12 ns;
end architecture arc;
--------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity and3 is
	port(a,b,c:in std_logic;
	f:    out std_logic);					  -- 3 inputs and gate
end entity and3; 

architecture arc of and3 is 
begin
	f<= (a) and (b) and (c) after 8 ns;
	end architecture arc;

-------------------------------------  

library ieee;
use ieee.std_logic_1164.all;

entity and4 is
	port(a,b,c,d:in std_logic;
	f:    out std_logic);							-- 4 inputs and gate
end entity and4; 

architecture arc of and4 is 
begin
	f<= (a) and (b) and (c) and (d) after 8ns;
	end architecture arc;

-----------------------------------------------  

library ieee;
use ieee.std_logic_1164.all;

entity or3 is
	port(a,b,c:in std_logic;
	f:    out std_logic);
end entity or3; 									 -- 3 inputs or gate

architecture arc of or3 is 
signal x:std_logic;
begin
	f<= (a) or (b) or (c) after 8ns;
	end architecture arc;

----------------------------------------------------	  

library ieee;
use ieee.std_logic_1164.all;

entity or4 is
	port(a,b,c,d:in std_logic;								 -- 4 inputs or gate
	f:    out std_logic);
end entity or4; 

architecture arc of or4 is 
begin
	f<= (a) or (b) or (c) or (d) after 8ns;
	end architecture arc;

------------------------------------------------ 

                  --Adders
-------------------------------------------------------------------

-- full adder structurly using gates

library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
	port(a,b,cin:in std_logic;
	sum,cout: out std_logic);
end entity full_adder;
															
architecture arc of full_adder is
signal temp1,temp2,temp3:std_logic;
begin 
	g1: entity work.xor2(arc) port map(a,b,temp1); -- calling the xor gate to find the sum of the first two bits
	g2: entity work.and2(arc) port map(a,b,temp2); -- calling the first and gate to find the first input for the or gate to get the carry
	g3: entity work.and2(arc) port map(cin,temp1,temp3);  -- calling the second and gate to find the second input for the or gate to get the carry
	g4: entity work.xor2(arc) port map(temp1,cin,sum);  -- calling the xor gate to find the sum of the three bits
	g5: entity work.or2(arc) port map(temp2,temp3,cout); -- calling the or gate to find the final carry
	end architecture arc;

------------------------------------------------------

-- 4-bit full adder structurly using 1-bit full adder

library ieee;
use ieee.std_logic_1164.all;

entity four_bit_adder is   	
	port(a,b:in std_logic_vector(3 downto 0); 
	     cin:in std_logic;
	      s: out std_logic_vector (3 downto 0);							 
	   cout: out std_logic);
end entity four_bit_adder;	 

architecture arc of four_bit_adder is
signal c:std_logic_vector(4 downto 0);
begin
	c(0)<=cin; -- moving the first carry to the carry vector
	g:
	for i in 0 to 3 generate	-- generate statement to reduce the size of the code
		g1:entity work.full_adder(arc) port map(a(i),b(i),c(i),s(i),c(i+1)); -- calling the full adder entity for all the bits with the previous carry
	end generate g;
	cout<=c(4);	   -- copying the last carry to the final carry of the system
end architecture arc;

------------------------------------------ 

-- carry generator for the four bit look ahead adder
	
library ieee;
use ieee.std_logic_1164.all;

entity carry_generator is
	port(v:in std_logic_vector(6 downto 0);
	c2,c3,c4:out std_logic);
end entity carry_generator;

architecture arc of carry_generator is
signal p1,p2,p3,g1,g2,g3,a,b,c,d,e,f:std_logic;	-- every pi stands for the sum from the ith half adder and gi stands for the carry from the ith half adder 
begin
	x1:entity work.and2(arc) port map(v(1),v(2),g1);
	x2:entity work.xor2(arc) port map(v(1),v(2),p1);
	x3:entity work.and2(arc) port map(v(3),v(4),g2);				 
	x4:entity work.xor2(arc) port map(v(3),v(4),p2);
	x5:entity work.and2(arc) port map(v(5),v(6),g3);
	x6:entity work.xor2(arc) port map(v(5),v(6),p3);
	x7:entity work.and2(arc) port map(v(0),p1,a);
	x8:entity work.or2(arc) port map(a,g1,c2);					-- this part works as same as discussed in the introduction part
	x9:entity work.and2(arc) port map(g1,p2,b);	
	x10:entity work.and3(arc) port map(p2,p1,v(0),c);
	x11:entity work.or3(arc) port map(b,c,g2,c3);
	x12:entity work.and2(arc) port map(g2,p3,d);
	x13:entity work.and3(arc) port map(g1,p2,p3,e);	
	x14:entity work.and4(arc) port map(v(0),p1,p2,p3,f);
    x15:entity work.or4(arc) port map(g3,f,e,d,c4);

end architecture arc;

-------------------------------------------------------------------

-- 4-bit look ahead adder structurly using carry generator


library ieee;
use ieee.std_logic_1164.all;

entity adder_look_ahead_4bit is
	port(a,b:in std_logic_vector(3 downto 0); 
	cin:in std_logic;
	s: out std_logic_vector(3 downto 0);
	cout: out std_logic);
end entity adder_look_ahead_4bit;

architecture arc of adder_look_ahead_4bit is
signal v:std_logic_vector(6 downto 0);
signal c1,c2,c3,c4:std_logic;
begin
	x1: entity work.full_adder(arc) port map(a(0),b(0),cin,s(0),c1);	-- calling the first adder to get the first carry	
	v(0)<=c1;
	v(1)<=a(1);
	v(2)<=b(1);
	v(3)<=a(2);			  -- initializing the vector that will be sent to the carry genrator
	v(4)<=b(2);
	v(5)<=a(3);
	v(6)<=b(3);
x2:entity work.carry_generator(arc) port map(v,c2,c3,c4); -- calling the carry generator to get all the needed carries
x3: entity work.full_adder(arc) port map(a(1),b(1),c1,s(1));	  -- calling the second full adder 
x4: entity work.full_adder(arc) port map(a(2),b(2),c2,s(2));   -- calling the third full adder
x5: entity work.full_adder(arc) port map(a(3),b(3),c3,s(3));  -- calling the fourth full adder
cout<=c4;  	 -- moving the last carry to the output carry of the system
end architecture arc;
-------------------------------------------------------------------

-- 1 bit bcd adder using ripple and look ahead adders


library ieee;
use ieee.std_logic_1164.all;

entity bcd_adder_onebit is
	port(a,b:in std_logic_vector(3 downto 0);
	cin:in std_logic; 
	s:out std_logic_vector(3 downto 0);
	cout:out std_logic);
end entity bcd_adder_onebit;

architecture ripple of bcd_adder_onebit is -- using ripple adder
signal x,y,w,cout_init:std_logic;   -- x and y are temp signals to store the output of the first and second and gates that checks if the number is more than 9 
signal ans_init,second:std_logic_vector(3 downto 0);-- vector to store the initail result before correcting it if necessary
begin
	g1: entity work.four_bit_adder(arc) port map (a,b,cin,ans_init,cout_init);	-- calling the four bit ripple adder by sending the 4 bits of each bcd digit
	g2:entity work.and2(arc) port map (ans_init(2),ans_init(3),x);	-- checking if the output if more than 9
	g3:entity work.and2(arc) port map (ans_init(3),ans_init(1),y);	-- checking if the output is more than 9
	g4:entity work.or3(arc) port map (cout_init,x,y,w);		-- determining if the output is more than 9 and storing 1 in w if so
	second(3)<='0';																			   
	second(2)<=w;	   -- inistializing the vector that will be added to the output to recorrect it
	second(1)<=w;					
	second(0)<='0';
	g6: entity work.four_bit_adder(arc) port map (ans_init,second,'0',s);	-- correcting the output by adding 6 to if if it is more than 9 and 0 otherwise
		cout<=w;	-- moving one tto the output carry if the number was corrected by adding 6 to it
	end architecture ripple;
	
architecture look_ahead of bcd_adder_onebit is 	-- using look ahead adder 
signal x,y,z,w,cout_init:std_logic;
signal ans_init,second:std_logic_vector(3 downto 0);
begin
	g1: entity work.adder_look_ahead_4bit(arc) port map (a,b,cin,ans_init,cout_init);
	g2:entity work.and2(arc) port map (ans_init(2),ans_init(3),x);
	g3:entity work.and2(arc) port map (ans_init(3),ans_init(1),y);
	g4:entity work.or2(arc) port map (cout_init,x,z);
	g5:entity work.or2(arc) port map (y,z,w);						   -- this is as same as the previous one but with changing the type of the 4-bits full adder
	second(3)<='0';
	second(2)<=w;
	second(1)<=w;
	second(0)<='0';
	g6: entity work.adder_look_ahead_4bit(arc) port map (ans_init,second,'0',s);
		cout<=w;
	end architecture look_ahead;
	
-------------------------------------------------------------------	
-- 2 bits bcd adder using 1-bit bcd adder and ripple adder
library ieee;
use ieee.std_logic_1164.all;

entity two_bit_bcd is
	port(a,b:in std_logic_vector(7 downto 0); 
	cin:std_logic;
	ans: out std_logic_vector (8 downto 0));
end entity two_bit_bcd;	

architecture ripple of two_bit_bcd is 
signal first_out,second_out,first_least,first_most,second_least,second_most: std_logic_vector(3 downto 0);-- vectors to store the most and least significant parts of each bcd number and for the outputs of each adder
signal c1out,cout:std_logic;
begin
	g:
	for i in 0 to 3 generate																									
		first_least(i)<=a(i);																		 
		second_least(i)<=b(i);	   -- moving the least and most bits of each number to their vectors
		first_most(i)<=a(i+4);
		second_most(i)<=b(i+4);
	end generate g;
	g1:entity work.bcd_adder_onebit(ripple) port map(first_least,second_least,cin,first_out,c1out);	  -- calling the first 1-digit bcd adder for the least bytes
	g2:entity work.bcd_adder_onebit(ripple) port map(first_most,second_most,c1out,second_out,cout);	 -- calling the second 1-digit bcd adder for the least bytes
	g3:
	for i in 0 to 3 generate		
		ans(i)<=first_out(i);		 -- moving the final result to the final answer vector
		ans(i+4)<=second_out(i);
	end generate g3;
	ans(8)<=cout;		  -- adding the last carry for the final answer
	end architecture ripple;
	
--------------------------------------------------------------------------------------------------------- 

-- 2 bits bcd adder using 1-bit bcd adder and look ahead adder


library ieee;
use ieee.std_logic_1164.all;

entity two_bit_bcd is
	port(a,b:in std_logic_vector(7 downto 0); 
	cin:std_logic;
	ans: out std_logic_vector (8 downto 0));
end entity two_bit_bcd;	

architecture look_ahead of two_bit_bcd is 
signal first_out,second_out,first_least,first_most,second_least,second_most: std_logic_vector(3 downto 0); 
signal c1out,cout:std_logic;
begin
	g:
	for i in 0 to 3 generate																									
		first_least(i)<=a(i);																		 
		second_least(i)<=b(i);		  
		first_most(i)<=a(i+4);														-- this is as same as the previous one but with changing the type of the 4-bits full adder
		second_most(i)<=b(i+4);
	end generate g;
	g1:entity work.bcd_adder_onebit(look_ahead) port map(first_least,second_least,cin,first_out,c1out); 
	g2:entity work.bcd_adder_onebit(look_ahead) port map(first_most,second_most,c1out,second_out,cout); 
	g3:
	for i in 0 to 3 generate		
		ans(i)<=first_out(i);
		ans(i+4)<=second_out(i);	
	end generate g3;
	ans(8)<=cout;	  
	end architecture look_ahead;

---------------------------------------------------

				--Registers
---------------------------------------------------	

-- 8 bit register ( for the input )
	
library ieee;
use ieee.std_logic_1164.all;

entity register_8_bit is 
	port(input1,input2:in std_logic_vector(7 downto 0);
	clk:in std_logic;
	output1,output2:out std_logic_vector(7 downto 0));
end entity register_8_bit;

architecture arc of register_8_bit is								  
begin
	process(clk)
	begin
	if(rising_edge(clk))
		then
		output1<=input1;
		output2<=input2;  -- just moving the input to the output on the rising edge of the clock
	end if;	  
	end process;
end architecture arc;	
------------------------------------------------
-- 9 bit register ( for the output)
	
library ieee;
use ieee.std_logic_1164.all;

entity register_9_bit is 
	port(input:in std_logic_vector(8 downto 0);
	clk,reset:in std_logic;
	output:out std_logic_vector(8 downto 0));
end entity register_9_bit;

architecture arc of register_9_bit is
begin																   
	process(clk,reset)
	begin
		if(reset = '1')		  -- checking if the reset is 1 to clear the register output
			then
			output<= (others => '0');
	elsif(rising_edge(clk))
		then				  -- just moving the input to the output on the rising edge of the clock
		output<=input;
	end if;	  
	end process;
end architecture arc;	
--------------------------------------------------------------------	 

					--Result Analyzer
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library STD;
use STD.textio.all;

entity result_analyzer is
	port(correct_answer,system_result:in std_logic_vector(8 downto 0);
	clk:in std_logic
	);
end entity result_analyzer;

ARCHITECTURE arc of result_analyzer IS
BEGIN
    PROCESS(clk)  
	file Fout : TEXT open WRITE_MODE is "out.txt"; -- initializing the output file pointer
	variable current_line : line;			 	-- initializng the line that will be used to write into the file
	variable v_TIME : time := 0 ns;				-- initializing a time variable to get the current time
	
    BEGIN
      IF rising_edge(clk) THEN 
	if(correct_answer /= system_result)	   -- chceking the result is incorrect
		then
		v_TIME:=now;			  -- making the time variable equals the current simulation time
		write(current_line,string'("Incorrect result at time "));  -- writng the warning to the line
		write(current_line,v_TIME);
		writeline (Fout,current_line);		   -- writing the line on the file
	end if;	
        ASSERT   correct_answer =  system_result  
        REPORT   "Adder output is incorrect" 	   -- asserting again if the result is correct with a warning serverity
        SEVERITY WARNING;
      END IF;
    END PROCESS;
  END ARCHITECTURE arc;
-----------------------------------------------------------------  	
--Full system

library ieee;
use ieee.std_logic_1164.all;
entity full_system is
	port(a,b:in std_logic_vector(7 downto 0);
	clk,reset:in std_logic;
	ans: out std_logic_vector(8 downto 0));
end entity full_system;

architecture ripple of full_system is
signal a_out,b_out: std_logic_vector(7 downto 0); 							  -- full system using ripple adder and all previous components structurly
signal out_init: std_logic_vector(8 downto 0);
begin
	g1:	entity work.register_8_bit(arc) port map (a,b,clk,a_out,b_out);	 -- calling the input register
	g2: entity work.two_bit_bcd(ripple) port map (a_out,b_out,'0',out_init); -- calling the 2 digits bcd adder
	g3:	entity work.register_9_bit(arc) port map (out_init,clk,reset,ans);-- calling the output register
end architecture ripple;	

architecture look_ahead of full_system is
signal a_out,b_out: std_logic_vector(7 downto 0); 							  -- full system using look ahead adder and all previous components structurly
signal out_init: std_logic_vector(8 downto 0);
begin
	g1:	entity work.register_8_bit(arc) port map (a,b,clk,a_out,b_out);
	g2: entity work.two_bit_bcd(look_ahead) port map (a_out,b_out,'0',out_init);
	g3:	entity work.register_9_bit(arc) port map (out_init,clk,reset,ans);	  
end architecture look_ahead;	

-------------------------------------------------------

				--Test Bench
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity test_bench is
end entity test_bench;	 

architecture arc of test_bench is	
signal a,b:std_logic_vector(7 downto 0):="00000000";
signal ans,correct_result:std_logic_vector(8 downto 0);
signal clk:std_logic:='0';
signal clk2:std_logic:='1';
signal reset:std_logic:='1';
begin
	clk<= (not clk) after 92 ns;		  -- here we set the clock time to the worst case as shown in the report
	clk2<= (not clk2) after 184 ns;		  -- here we set the clock time to double the worst case also as shown in the report //this clock is explained in deatails in the report
	reset<= '0' after 105 ns;
	process
	variable num1_least,num2_least,num1_most,num2_most,ans_least,ans_least_correct,ans_most,ans_most_correct:std_logic_vector (4 downto 0):="00000"; -- variables will be shown during disucssing the code
	begin
		for i in 0 to 9 loop -- most signifacant bits of the first number
			for j in 0 to 9 loop  -- least signifacant bits of the first number
				for k in 0 to 9 loop -- most signifacant bits of the second number
					for w in 0 to 9 loop -- least signifacant bits of the second number
						a(7 downto 4)<= CONV_STD_LOGIC_VECTOR(i,4);
						a(3 downto 0)<= CONV_STD_LOGIC_VECTOR(j,4);	   -- moving each number to the input vectors from its most and least significant parts
						b(7 downto 4)<= CONV_STD_LOGIC_VECTOR(k,4);
				   		b(3 downto 0)<= CONV_STD_LOGIC_VECTOR(w,4);
						 num1_least(4):='0';
						 num1_least(3 downto 0 ) := CONV_STD_LOGIC_VECTOR(j,4);	
						 num1_most(4):='0';
						 num1_most(3 downto 0 ) := CONV_STD_LOGIC_VECTOR(i,4);
						 num2_least(4):='0';									--also moving each number to the variables used to find the correct tesult from its most and least significant parts 
						 num2_least(3 downto 0 ) := CONV_STD_LOGIC_VECTOR(w,4);
						 num2_most(4):='0';
						 num2_most(3 downto 0 ) := CONV_STD_LOGIC_VECTOR(k,4);	
						 
      					ans_least:= num1_least +num2_least;				-- adding the least sginifacant part of each number
						  
						if ans_least > 9 then	   -- checkin if the result is more than 9
							ans_least_correct := "00110" + ans_least;	 -- adding 6 to it if so
							ans_most := "00001" +num1_most+num2_most;	-- adding the most significant one with one from the previous least part
							ans_most_correct:=ans_most;
							if(ans_most > 9) then
								ans_most_correct:="00110"+ans_most;	 -- also adding 6 to the rsult if its more than 9
							end if;
							correct_result (3 downto 0) <=ans_least_correct(3 downto 0);  -- moving the correct result to the correct_result vector
							correct_result (8 downto 4) <=ans_most_correct(4 downto 0);
						else
							ans_most := num1_most+num2_most;
							ans_most_correct:=ans_most;		   -- other wise adding the most significant parts without a previous carry
							if(ans_most > 9) then
								ans_most_correct:="00110"+ans_most;  --  adding 6 to the rsult if its more than 9
							end if;
							correct_result (3 downto 0)<=ans_least(3 downto 0);
							correct_result (8 downto 4)<=ans_most_correct(4 downto 0);	-- moving the correct result to the correct_result vector
						end if;
   					wait until rising_edge(clk2); -- wait until the rusing edge of the second clock to make sure that the adder completes its work and the correct result is a the output of the register
					end loop;				   -- this part is explained in details in the report
				end loop;
			end loop;
		end loop;
		wait;
	end process;
	g1:entity work.full_system (ripple) port map (a,b,clk,reset,ans);--calling the full system to fin the sum	( you can use the look ahead adder by changing the ARchitecture to look_ahead and clock 1 to 85ns and clock 2 to 170ns )
	g2:entity work.result_analyzer (arc) port map (correct_result,ans,clk2); -- calling the result analyzer to check the result
END ARchitecture arc;

			
			
			
	
		

	






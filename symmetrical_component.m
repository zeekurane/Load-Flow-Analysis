%{
These two symbols mean whatever is written between them is in form of comments for matlab. There should not be anything else in the line where these two symbols are present.
%}

%{
Explanaiton about commands and methods used :
1) C = inv(D) --> D is a square matrix and its inverse is stored in variable C
2) ";" hides the output in command window
3) C = pol2cart(theta in radian, magnitude) --> converts the complex number from polar to rectangular form, but it stores the real and imaginary part in a matrix of 1 row 2 columns. Ex. C = pol2cart(pi/6, 10), here C will be [0.8660, 0.5000]
4) I've manually converted from degrees to radian by formula, radian = degree*pi/180. Other methods include function radian = deg2rad(degree)
5) similarly, for conversion of radian to degree, function is degree = rad2deg(radian)
6) OP --> means Original Phasors
7) CP --> means Component Phasors
8) return; --> this line returns 0 and the code is quit. Its used here to stop the code at an error before its completion
9) "\n" --> newline operator, it just continues its work on a new line in command window
10) char(8736) --> 8736 is the unicode for angle symbol. It will just display the angle symbol.
11) char(960) --> 960 is the unicode for pi symbol. It will just display the pi symbol.
12) char(176) --> 176 is unicode for degree symbol. It will show circle as a superscript.
13) char(13) --> 13 is unicode for newline.
14) abs(C) --> It will give magnitude or absolute value of the complex number C.
15) angle(C) --> It will give angle in radians of the complex number C.
16) num2str(C) --> It converts C, which is a number (complex or real) into string. If C=1+i*6 you print C, you will only get 1+i*6 as output, but num2str(C) gives "1+i*6" as output, which then can be used in disp function to display it.
17) disp() --> displays stuff on command window
%}


clear % To clear all previous data stored in workspace or memory which includes variables
clc % To clean Command Window

A = [1 1 1; 1 -0.5+1i*0.5*(3).^(1/2) -0.5-1i*0.5*(3).^(1/2); 1 -0.5-1i*0.5*(3).^(1/2) -0.5+0.5*1i*(3).^(1/2)];
% matrix A -> symmetrical component transform matrix can also be calculated as given below
% alpha = -(1/2)+i*(1/2)*(3).^(1/2)
% or
% alpha = 1*exp(i*2*pi/3)
% A = [1 1 1; 1 alpha alpha.^2; 1 alpha.^2 alpha]
A_inv = inv(A); % inverse of matrix A

choice_1 = input('Do you want to calculate values of Original Phasors (Component Synthesis) ?\n--> [Y/N] : ', 's'); % Question : Component Synthesis / Component Analysis

if choice_1=='N' % Component Analysis ((V or I)_abc --> (V or I)_012)
    choice_2 = input('Do you want to enter the Original Phasors in rectangular form ?\n--> [Y/N] : ','s'); % Question : Rectangular (x+i*y) / Polar (theta, r)
    
    if choice_2=='N' % Polar (theta, r)
        choice_3 = input('Do you want to enter the angles in radian ?\n--> [Y/N] : ', 's'); % Question : Radians / Degrees
        
        if choice_3=='Y' % Radians
            OP_a = input('Enter current or voltage value (phase a or phase R) in polar form:\n--> [angle in radian, magnitude] : ');
            OP_b = input('Enter current or voltage value (phase b or phase Y) in polar form:\n--> [angle in radian, magnitude] : ');
            OP_c = input('Enter current or voltage value (phase c or phase B) in polar form:\n--> [angle in radian, magnitude] : ');
            [xa, ya] = pol2cart(OP_a(1), OP_a(2));
            [xb, yb] = pol2cart(OP_b(1), OP_b(2));
            [xc, yc] = pol2cart(OP_c(1), OP_c(2));
        
        elseif choice_3=='N' % Degrees
            OP_a = input('Enter current or voltage value (phase a or phase R) in polar form:\n--> [angle in degree, magnitude] : ');
            OP_b = input('Enter current or voltage value (phase b or phase Y) in polar form:\n--> [angle in degree, magnitude] : ');
            OP_c = input('Enter current or voltage value (phase c or phase B) in polar form:\n--> [angle in degree, magnitude] : ');
            [xa, ya] = pol2cart(OP_a(1)*pi/180, OP_a(2));
            [xb, yb] = pol2cart(OP_b(1)*pi/180, OP_b(2));
            [xc, yc] = pol2cart(OP_c(1)*pi/180, OP_c(2));
        
        else
            disp('Error! Value can either be Y or N only!');
            return;
        
        end
        
        OP_abc = [xa+1i*ya; xb+1i*yb; xc+1i*yc]
        CP_012 = A_inv*OP_abc;
    
    elseif choice_2=='Y' % Rectangular (x+i*y)
        OP_a = input('Enter current or voltage value (phase a or phase R) in rectangular form:\n--> real+i*imaginary : ');
        OP_b = input('Enter current or voltage value (phase b or phase Y) in rectangular form:\n--> real+i*imaginary : ');
        OP_c = input('Enter current or voltage value (phase c or phase B) in rectangular form:\n--> real+i*imaginary : ');
        
        OP_abc = [OP_a; OP_b; OP_c]
        CP_012 = A_inv*OP_abc;
    
    else
        disp('Error! Value can either be Y or N only!');
        return;
    
    end

    % displaying component phasors in rectangular form as default
    disp(['zero sequence component = ',num2str(CP_012(1)),' volts or amperes']);
    disp(['positive sequence component = ',num2str(CP_012(2)),' volts or amperes']);
    disp(['negative sequence component = ',num2str(CP_012(3)),' volts or amperes']);

    choice_4 = input('Do you want component phasors in polar form also ?\n--> [Y/N] : ','s'); % Question : Also want output in polar form

    if choice_4=='Y' % Polar form output in degrees as well as in radians
        
        disp(['Zero sequence component = ', num2str(abs(CP_012(1))), ' ', char(8736), num2str(rad2deg(angle(CP_012(1)))), char(176), ' volts or amperes', char(13), 'Zero sequence component = ', num2str(abs(CP_012(1))), ' ', char(8736), num2str(angle(CP_012(1))/pi), char(960), ' rad volts or amperes']);
        disp(['Positive sequence component = ', num2str(abs(CP_012(2))), ' ', char(8736), num2str(rad2deg(angle(CP_012(2)))), char(176), ' volts or amperes', char(13), 'Positive sequence component = ', num2str(abs(CP_012(2))), ' ', char(8736), num2str(angle(CP_012(2))/pi), char(960), ' rad volts or amperes']);
        disp(['Negative sequence component = ', num2str(abs(CP_012(3))), ' ', char(8736), num2str(rad2deg(angle(CP_012(3)))), char(176), ' volts or amperes', char(13), 'Negative sequence component = ', num2str(abs(CP_012(3))), ' ', char(8736), num2str(angle(CP_012(3))/pi), char(960), ' rad volts or amperes']);

    end

elseif choice_1=='Y' % Component Synthesis ((V or I)_012 --> (V or I)_abc)
    choice_2 = input('Do you want to enter the Component Phasors in rectangular form ?\n--> [Y/N] : ', 's'); % Question : Rectangular (x+i*y) / Polar (theta, r)
    
    if choice_2=='N' % Polar (theta, r)
        choice_3 = input('Do you want to enter the angles in radian ?\n--> [Y/N] : ', 's'); % Question : Radians / Degrees
        
        if choice_3=='Y' % Radians
            CP_0 = input('Enter zero sequence current or voltage value in polar form:\n--> [angle in radian, magnitude] : ');
            CP_1 = input('Enter positive sequence current or voltage values in polar form:\n--> [angle in radian, magnitude] : ');
            CP_2 = input('Enter negative sequence current or voltage values in polar form:\n--> [angle in radian, magnitude] : ');
            [x0, y0] = pol2cart(CP_0(1), CP_0(2));
            [x1, y1] = pol2cart(CP_1(1), CP_1(2));
            [x2, y2] = pol2cart(CP_2(1), CP_2(2));
        
        elseif choice_3=='N' % Degrees
            CP_0 = input('Enter zero sequence current or voltage values in polar form:\n--> [angle in degree, magnitude] : ');
            CP_1 = input('Enter positive sequence current or voltage values in polar form:\n--> [angle in degree, magnitude] : ');
            CP_2 = input('Enter negative sequence current or voltage values in polar form:\n--> [angle in degree, magnitude] : ');
            [x0, y0] = pol2cart(CP_0(1)*pi/180, CP_0(2));
            [x1, y1] = pol2cart(CP_1(1)*pi/180, CP_1(2));
            [x2, y2] = pol2cart(CP_2(1)*pi/180, CP_2(2));
        
        else
            disp('Error! Value can either be Y or N only!');
            return;
        
        end
        
        CP_012 = [x0+1i*y0; x1+1i*y1; x2+1i*y2]
        OP_abc = A*CP_012;
    
    elseif choice_2=='Y' % Rectangular (x+i*y)
        CP_0 = input('Enter zero sequence current or voltage values in rectangular form:\n--> real+i*imaginary : ');
        CP_1 = input('Enter positive sequence current or voltage values in rectangular form:\n--> real+i*imaginary : ');
        CP_2 = input('Enter negative sequence current or voltage values in rectangular form:\n--> real+i*imaginary : ');
        
        CP_012 = [CP_0; CP_1; CP_2]
        OP_abc = A*CP_012;
    
    else
        disp('Error! Value can either be Y or N only!');ss
        return;
    
    end

    % displaying original phasors in rectangular form as default
    disp(['Phase a or R = ',num2str(OP_abc(1)),' volts or amperes']);
    disp(['Phase b or Y = ',num2str(OP_abc(2)),' volts or amperes']);
    disp(['Phase c or B = ',num2str(OP_abc(3)),' volts or amperes']);

    choice_4 = input('Do you want original phasors in polar form also ?\n--> [Y/N] : ', 's'); % Question : Also want output in polar form

    if choice_4=='Y' % Polar form output in degrees as well as in radians
        
        disp(['Phase a or R = ', num2str(abs(OP_abc(1))), ' ', char(8736), num2str(rad2deg(angle(OP_abc(1)))), char(176), ' volts or amperes', char(13), 'Phase a or R = ', num2str(abs(OP_abc(1))), ' ', char(8736), num2str(angle(OP_abc(1))/pi), char(960), ' rad volts or amperes']);
        disp(['Phase b or Y = ', num2str(abs(OP_abc(2))), ' ', char(8736), num2str(rad2deg(angle(OP_abc(2)))), char(176), ' volts or amperes', char(13), 'Phase b or Y = ', num2str(abs(OP_abc(2))), ' ', char(8736), num2str(angle(OP_abc(2))/pi), char(960), ' rad volts or amperes']);
        disp(['Phase c or B = ', num2str(abs(OP_abc(3))), ' ', char(8736), num2str(rad2deg(angle(OP_abc(3)))), char(176), ' volts or amperes', char(13), 'Phase c or B = ', num2str(abs(OP_abc(3))), ' ', char(8736), num2str(angle(OP_abc(3))/pi), char(960), ' rad volts or amperes']);

    end

else
    disp('Error! Value can either be Y or N only!');
    return;

end
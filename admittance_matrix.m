%{
These two symbols mean whatever is written between them is in form of comments for matlab. There should not be anything else in the line where these two symbols are present.
%}

%{
Y bus calculation by Singular Transformation Method :
We can get Y bus by different methods like direct method. Here, input is generally in rectangular form, whether impedance or admittance is concerned, hence not coded for input in polar form, as it gets more lengthy and difficult to understand.

Explanaiton about commands and methods used :
1) C = inv(D) --> D is a square matrix and its inverse is stored in variable C
2) ";" hides the output in command window
3) return; --> this line returns 0 and the code is quit. Its used here to stop the code at an error before its completion
4) "\n" --> newline operator, it just continues its work on a new line in command window
5) char(8736) --> 8736 is the unicode for angle symbol. It will just display the angle symbol.
6) char(960) --> 960 is the unicode for pi symbol. It will just display the pi symbol.
7) char(176) --> 176 is unicode for degree symbol. It will show circle as a superscript.
8) char(433) --> 433 is unicode for 'mho', unit of admittance. 'S', siemens also can be used.
9) abs(C) --> It will give magnitude or absolute value of the complex number C.
10) angle(C) --> It will give angle in radians of the complex number C.
11) num2str(C) --> It converts C, which is a number (complex or real) into string. If C=1+i*6 you print C, you will only get 1+i*6 as output, but num2str(C) gives "1+i*6" as output, which then can be used in disp function to display it.
12) disp() --> displays stuff on command window
13) isnumeric(C) --> It outputs either 1 or 0, binary, logical which resembles True or False respectfully. It checks whether C is number, real or complex and return 1 otherwise returns 0
14) A' --> Transpose of A matrix
15) real(C) --> returns real part of complex number C
16) imag(C) --> returns imaginary part of complex number C
%}

clear % To clear all previous data stored in workspace or memory which includes variables
clc % To clean Command Window

num_of_buses = input('What is total number of buses: '); % Question : number of buses
num_of_transmission_lines = input('What is the total number of transmission lines: '); % Question : number of transmission lines
bus_incidence_matrix = zeros(num_of_transmission_lines, num_of_buses); % Initializing bus incidence matrix
iterator = num_of_transmission_lines;


% Bus incidence matrix
while iterator>0
    prompt = ['Transmission line number ', num2str(num_of_transmission_lines-iterator+1),' is between which buses?\nDenote like this if the transmission line is between bus 1 and bus 2 --> [1 2] : '];
    a = input(prompt);

    if bus_incidence_matrix(num_of_transmission_lines-iterator+1, a(1))==0 && bus_incidence_matrix(num_of_transmission_lines-iterator+1, a(2))==0
        bus_incidence_matrix(num_of_transmission_lines-iterator+1, a(1)) = 1;
        bus_incidence_matrix(num_of_transmission_lines-iterator+1, a(2)) = -1;
        iterator = iterator-1;
    else
        disp('Error! Give the input in required format.');
    end
end


choice_1 = input('Do you have admittances of the transmission lines ?\n[Y/N] : ', 's'); % Question : Admittances / Impedances

if choice_1=='Y' % Admittances
    y_primitive = zeros(num_of_transmission_lines); % Initializing y_primitive matrix
    % self admittances
    iterator = num_of_transmission_lines;

    while iterator>0
        prompt = ['Enter the self admittance of transmission line number ', num2str(num_of_transmission_lines-iterator+1),'\n--> x+i*y : '];
        b = input(prompt);
        
        if isnumeric(b)
            y_primitive(num_of_transmission_lines-iterator+1, num_of_transmission_lines-iterator+1) = b;
            iterator = iterator-1;
        else
            disp('Error! Give the input in required format.');
        end
    end
    
    % mutual admittances
    choice_2 = input('Are there non-zero mutual admittances between transmission lines ?\n[Y/N] : ', 's'); % Question : Non-zero mutual admittances between lines ?
    
    if choice_2=='Y'
        num_of_mutual_admittances = input('Enter the number of non-zero mutual admittances between transmission lines.\nMutual admittance of a line with another line and its vice-versa is considered to be 1 and the same mutual admittance : ');
        if isnumeric(num_of_mutual_admittances)
            iterator = num_of_mutual_admittances;
            
            while iterator>0
                c = input('Enter the non-zero mutual admittance (x+i*y) between transmission lines a and b as,\n--> [a, b, x+i*y] : ');
                if ((0<c(1)) && (c(1)<=num_of_transmission_lines)) && ((0<c(2)) && (c(2)<=num_of_transmission_lines)) && isnumeric(c(3)) && y_primitive(c(1),c(2))==0 && (real(c(3))~=0 || imag(c(3))~=0)
                    y_primitive(c(1), c(2)) = c(3);
                    y_primitive(c(2), c(1)) = c(3);
                    iterator = iterator-1;
                else
                    disp('Error! Give the input in required format.');
                end
            end
        else
            disp('Error! Give numeric input.');
            return;
        end
    
    elseif choice_2~='N'
        disp('Error! Value can either be Y or N only!');
        return;
    end
    
elseif choice_1=='N' % Impedances
    z_primitive = zeros(num_of_transmission_lines); % Initializing z_primitive matrix
    % self impedances
    iterator = num_of_transmission_lines;
    
    while iterator>0
        prompt = ['Enter the self impedance of transmission line number ', num2str(num_of_transmission_lines-iterator+1),'\n--> x+i*y : '];
        b = input(prompt);
        if isnumeric(b)
            z_primitive(num_of_transmission_lines-iterator+1, num_of_transmission_lines-iterator+1) = b;
            iterator = iterator-1;
        else
            disp('Error! Give the input in required format.');
        end
    end
    
    % mutual impedances
    choice_2 = input('Are there non-zero mutual impedances between transmission lines ?\n[Y/N] : ', 's'); % Question : Non-zero mutual impedances between lines ?
    
    if choice_2=='Y'
        num_of_mutual_impedances = input('Enter the number of non-zero mutual impedances between transmission lines.\n*Mutual impedance of a line with another line and its vice-versa is considered to be 1 and the same mutual impedance* : ');
        if isnumeric(num_of_mutual_impedances)
            iterator = num_of_mutual_impedances;
            
            while iterator>0
                c = input('Enter the non-zero mutual impedance (x+i*y) between transmission lines a and b as\n--> [a, b, x+i*y] : ');
                if ((0<c(1)) && (c(1)<=num_of_transmission_lines)) && ((0<c(2)) && (c(2)<=num_of_transmission_lines)) && isnumeric(c(3)) && z_primitive(c(1),c(2))==0 && (real(c(3))~=0 || imag(c(3))~=0)
                    z_primitive(c(1), c(2)) = c(3);
                    z_primitive(c(2), c(1)) = c(3);
                    iterator = iterator-1;
                else
                    disp('Error! Give the input in required format.');
                end
            end
        else
            disp('Error! Give numeric input.');
            return;
        end
    
    elseif choice_2~='N'
        disp('Error! Value can either be Y or N only!');
        return;
    end
    
    y_primitive = inv(z_primitive); % y_primitive is the inverse matrix of z_primitive

else
    disp('Error! Value can either be Y or N only!');
    return;
end

Y_bus = bus_incidence_matrix'*y_primitive*bus_incidence_matrix; % Calculating Y_bus matrix
Y_bus
disp(['All units are in ', char(433)]);

choice_3 = input('Do you want Y bus matrix in polar form also ?\n[Y/N] : ','s'); % Question : Output in polar form also ?

if choice_3=='Y' % Output in polar form
    for R = 1:num_of_buses
         for C = 1:num_of_buses
             disp(['Y', num2str(R), num2str(C), ' = ', num2str(abs(Y_bus(R,C))), ' ', char(8736), num2str(rad2deg(angle(Y_bus(R,C)))), char(176)]);
         end
    end
    disp(['All units are in ', char(433), ' and angles in degree.']);

    for R = 1:num_of_buses
         for C = 1:num_of_buses
             disp(['Y', num2str(R), num2str(C), ' = ', num2str(abs(Y_bus(R,C))), ' ', char(8736), num2str(angle(Y_bus(R,C))/pi), char(960)]);
         end
    end
    disp(['All units are in ', char(433), ' and angles in radian.']);
end
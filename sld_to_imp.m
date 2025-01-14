% Input number of buses
num_of_buses = input('What is the total number of buses? : ');
% Data structure to store all data in one place
line_entities = cell(num_of_buses, num_of_buses);
%{
Attributes of relative places for each data point in an entity
line_entities{m,m}-->bus-->{MVA,voltage,new_voltage,('ohm' or 'pu'),x",pu_imp}
line_entities{m,n}-->entities between buses-->
1) Transformer-->{'Tx',MVA,primary_voltage,secondary_voltage,new_primary_voltage,new_secondary_voltage,('ohm' or 'pu'),('Lv' or 'Hv'),x,pu_imp}
2) Transmission Line-->{'Tl',new_voltage,impedance,pu_imp}
%}

% Data gathering

for m = 1:num_of_buses 
    
    % Bus data
    line_entities{m,m}={input(sprintf('MVA rating of bus %d : ', m)),input(sprintf('Voltage rating of bus %d in KV : ', m)),0,input('What is the unit for bus impedance?\n--> ohm or pu : ','s'),input('x" : '),0};
    
    for n = m+1:num_of_buses

        % Line or connection data between buses
        is_conn = input(sprintf('Is there connection between bus %d and bus %d?\n--> Y/N : ', m, n), 's');
        
        if is_conn == "Y"
            num = input(sprintf('What is the total number of transformers and transmission lines in the line from bus %d to bus %d? : ', m, n));
            if num~=0
                fprintf('Enter the entity one by one from bus %d to bus %d\nUse "Tx" for Transformer and "Tl" for Transmission Line\n',m,n);
                for k = 1:num
                    ent=input(sprintf('What is the entity %d?\n--> Tx (Transformer) or Tl (Transmission line) : ',k),'s');
                    
                    % Transformer data
                    if ent=="Tx"
                        mvat=input(sprintf('MVA rating of transformer : '));
                        vol = input(sprintf('Voltage rating of transformer %d in KV, from bus %d to bus %d \n--> example, [5 10] : ', k, m, n));
                        unit=input('What is the unit for transformer impedance?\n--> ohm or pu : ','s');
                        if unit=="ohm"
                            side=input('Which side is the impedance of?\nLv (Low voltage) or Hv (High voltage) : ','s');
                            xt=input(sprintf('x per phase : '));
                        else
                            xt=input(sprintf('x : '));
                            side="any";
                        end

                        % data storing method for iterative user inputs for multi-type data i.e. string, numeric, etc
                        if k==1
                            line_entities{m,n} = {'Tx',mvat, vol(1), vol(2),0,0, unit, side, xt,0};
                            line_entities{n,m} = {'Tx',mvat, vol(2), vol(1),0,0, unit, side, xt,0};
                        else
                            line_entities{m,n} = {line_entities{m,n}{:},'Tx',mvat, vol(1), vol(2),0,0, unit, side, xt,0};
                            line_entities{n,m} = {'Tx',mvat, vol(2), vol(1),0,0, unit, side, xt,0,line_entities{n,m}{:}};
                        end
                        
                    % Transmission line data
                    elseif ent=="Tl"
                        values = input('Per phase impedance of transmission line\n--> example, 2+i3 : ');
                        if k==1
                            line_entities{m,n} = {'Tl',0,values,0};
                            line_entities{n,m} = {'Tl',0,values,0};
                        else
                            line_entities{m,n} = {line_entities{m,n}{:},'Tl',0,values,0};
                            line_entities{n,m} = {'Tl',0,values,0,line_entities{n,m}{:}};
                        end
                    
                    else
                        disp('Error!')
                    end
                end
            % It means bus m and bus n are connected directly without any entities like transformers or transmission lines and hence 0 represents resistance of line i.e. pure connection
            elseif num==0
                line_entities{m,n} = {0};
                line_entities{n,m} = {0};
            end
        end
    end
end



% Base MVA and KV input
mva_base = input('Enter base MVA: ');
kv_base = input('Enter base KV: ');

% Considering bus 1 as reference
line_entities{1,1}{3}=kv_base;


% Data calculations (base voltages for each entity)
for m = 1:num_of_buses
    for n = m+1:num_of_buses
        if ~isempty(line_entities{m,n})
            
            if line_entities{m,m}{3}~=0
                old_kv_base = line_entities{m,m}{3};
                for k =1:length(line_entities{m,n})
                    if ischar(line_entities{m,n}{k}) && line_entities{m,n}{k}=="Tl"
                        line_entities{m,n}{k+1}=old_kv_base;
                    elseif ischar(line_entities{m,n}{k}) && line_entities{m,n}{k}=="Tx"
                        line_entities{m,n}{k+4}=old_kv_base;
                        old_kv_base=(line_entities{m,n}{k+3}/line_entities{m,n}{k+2})*old_kv_base;
                        line_entities{m,n}{k+5}=old_kv_base;
                    end
                end
                line_entities{n,n}{3} = old_kv_base;
            
            else
                old_kv_base = line_entities{n,n}{3};
                for k =1:length(line_entities{n,m})
                    if ischar(line_entities{n,m}{k}) && line_entities{n,m}{k}=="Tl"
                        line_entities{n,m}{k+1}=old_kv_base;
                    elseif ischar(line_entities{n,m}{k}) && line_entities{n,m}{k}=="Tx"
                        line_entities{n,m}{k+4}=old_kv_base;
                        old_kv_base=(line_entities{n,m}{k+3}/line_entities{n,m}{k+2})*old_kv_base;
                        line_entities{n,m}{k+5}=old_kv_base;
                    end
                end
                line_entities{m,m}{3} = old_kv_base;
            end

        end
    end
end


% Impedance calculations
for m = 1:num_of_buses
    for n = m:num_of_buses
        if m == n
            if line_entities{m,n}{4}=="ohm"
                line_entities{m,n}{6}=line_entities{m,n}{5}*mva_base/(line_entities{m,n}{3})^2;
            elseif line_entities{m,n}{4}=="pu"
                line_entities{m,n}{6}=line_entities{m,n}{5}*(mva_base*(line_entities{m,n}{2})^2)/(line_entities{m,n}{1}*(line_entities{m,n}{3})^2);
            end
        elseif ~isempty(line_entities{m,n})
            if (ischar(line_entities{m,n}{1}) && line_entities{m,n}{1}=="Tx"  && line_entities{m,n}{5}~=0) || (ischar(line_entities{m,n}{1}) && line_entities{m,n}{1}=="Tl"  && line_entities{m,n}{2}~=0)
                a=m;
                b=n;
            else
                a=n;
                b=m;
            end

            for k =1:length(line_entities{a,b})
                if ischar(line_entities{a,b}{k}) && line_entities{a,b}{k}=="Tl"
                    line_entities{a,b}{k+3}=line_entities{a,b}{k+2}*mva_base/(line_entities{a,b}{k+1})^2;
                elseif ischar(line_entities{a,b}{k}) && line_entities{a,b}{k}=="Tx"
                    if line_entities{a,b}{k+7}=="Lv"
                        line_entities{a,b}{k+9}=line_entities{a,b}{k+8}*mva_base/(min(line_entities{a,b}{k+4},line_entities{a,b}{k+5}))^2;
                    elseif line_entities{a,b}{k+7}=="Hv"
                        line_entities{a,b}{k+9}=line_entities{a,b}{k+8}*mva_base/(max(line_entities{a,b}{k+4},line_entities{m,n}{k+5}))^2;
                    elseif line_entities{a,b}{k+7}=="any"
                        line_entities{a,b}{k+9}=line_entities{a,b}{k+8}*(mva_base*(line_entities{a,b}{k+2})^2)/(line_entities{a,b}{k+1}*(line_entities{a,b}{k+4})^2);
                    end
                end
            end

        end
    end
end

% Displaying Impedances and Connections
disp('Impedances : ');
for m = 1:num_of_buses
    for n = m:num_of_buses
        if m == n
            fprintf('Bus %d : %f pu\n', m, line_entities{m,n}{6});
        elseif ~isempty(line_entities{m,n})
            if isscalar(line_entities{m,n})
                fprintf('Bus %d is connected to Bus %d\n', m, n)
                continue
            end
            if (ischar(line_entities{m,n}{1}) && line_entities{m,n}{1}=="Tx"  && line_entities{m,n}{5}~=0) || (ischar(line_entities{m,n}{1}) && line_entities{m,n}{1}=="Tl"  && line_entities{m,n}{2}~=0)
                a=m;
                b=n;
            else
                a=n;
                b=m;
            end
            fprintf('Inbetween Bus %d and Bus %d :\n', m, n);
            for k =1:length(line_entities{a,b})
                if ischar(line_entities{a,b}{k}) && line_entities{a,b}{k}=="Tl"
                    fprintf('%f pu ', line_entities{a,b}{k+3});
                elseif ischar(line_entities{a,b}{k}) && line_entities{a,b}{k}=="Tx"
                    fprintf('%f pu ', line_entities{a,b}{k+9});
                end
            end
            fprintf('\n')
        else
            fprintf('Bus %d is not connected to Bus %d\n', m, n);
        end
    end
end
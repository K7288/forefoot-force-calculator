classdef forefoot_force_calculator_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        TabGroup                    matlab.ui.container.TabGroup
        thefirstrayTab              matlab.ui.container.Tab
        Image4                      matlab.ui.control.Image
        F1Label                     matlab.ui.control.Label
        F1Value                     matlab.ui.control.NumericEditField
        JointButtonGroup            matlab.ui.container.ButtonGroup
        IPButton                    matlab.ui.control.RadioButton
        MPButton                    matlab.ui.control.RadioButton
        TMButton                    matlab.ui.control.RadioButton
        MTHButton                   matlab.ui.control.RadioButton
        NLabel_6                    matlab.ui.control.Label
        NLabel_7                    matlab.ui.control.Label
        GroundReactionForceLabel    matlab.ui.control.Label
        F2EditFieldLabel            matlab.ui.control.Label
        F2Value                     matlab.ui.control.NumericEditField
        Model1                      matlab.ui.control.Image
        UITable                     matlab.ui.control.Table
        Spinner                     matlab.ui.control.Spinner
        Spinner_2                   matlab.ui.control.Spinner
        Spinner_4                   matlab.ui.control.Spinner
        Spinner_6                   matlab.ui.control.Spinner
        Spinner_7                   matlab.ui.control.Spinner
        Spinner_8                   matlab.ui.control.Spinner
        Spinner_18                  matlab.ui.control.Spinner
        Spinner_19                  matlab.ui.control.Spinner
        Spinner_23                  matlab.ui.control.Spinner
        Spinner_24                  matlab.ui.control.Spinner
        Spinner_25                  matlab.ui.control.Spinner
        Spinner_26                  matlab.ui.control.Spinner
        thesecondrayTab             matlab.ui.container.Tab
        JointButtonGroup_2          matlab.ui.container.ButtonGroup
        DIPButton                   matlab.ui.control.RadioButton
        MPButton_2                  matlab.ui.control.RadioButton
        TMButton_2                  matlab.ui.control.RadioButton
        MTHButton_2                 matlab.ui.control.RadioButton
        PIPButton                   matlab.ui.control.RadioButton
        G1EditField                 matlab.ui.control.NumericEditField
        G1EditFieldLabel            matlab.ui.control.Label
        NLabel_8                    matlab.ui.control.Label
        NLabel_9                    matlab.ui.control.Label
        GroundReactionForceLabel_2  matlab.ui.control.Label
        G2EditFieldLabel            matlab.ui.control.Label
        G2EditField                 matlab.ui.control.NumericEditField
        Image2_3                    matlab.ui.control.Image
        UITable_2                   matlab.ui.control.Table
        Image4_2                    matlab.ui.control.Image
        Spinner_9                   matlab.ui.control.Spinner
        Spinner_10                  matlab.ui.control.Spinner
        Spinner_11                  matlab.ui.control.Spinner
        Spinner_12                  matlab.ui.control.Spinner
        Spinner_13                  matlab.ui.control.Spinner
        Spinner_14                  matlab.ui.control.Spinner
        Spinner_16                  matlab.ui.control.Spinner
        Spinner_17                  matlab.ui.control.Spinner
        Spinner_20                  matlab.ui.control.Spinner
        Spinner_21                  matlab.ui.control.Spinner
        Spinner_22                  matlab.ui.control.Spinner
        Spinner_27                  matlab.ui.control.Spinner
        Spinner_28                  matlab.ui.control.Spinner
        Spinner_29                  matlab.ui.control.Spinner
        Spinner_30                  matlab.ui.control.Spinner
    end

    properties (Access = private)
        % initialization
        distal1 = 20; proximal1 = 36; meta1 = 63 % lengths of bones of the first ray
        distal2 = 7;  middle2 = 15; proximal2 = 29; meta2 = 76 % lengths of bones of the second ray
        r_IP = 8; r_MP1 = 13; % radii of curvature of joints of the first ray
        r_DIP = 3; r_PIP = 4; r_MP2 = 7; % radii of curvature of joints of the second ray
        d_MP_hall = 12; d_MTH_hl = 25; d_MTH_hb = 22; d_DIP_dl = 14; d_PIP_d = 10; d_MP_d = 10; d_MTH_dl = 26; d_MTH_db = 16;% degrees between joints and muscles
        d_meta1 = 35; d_meta2 = 38;
        l_TM_hl = 34; l_TM_hb = 38; l_TM_pls = 25; l_TM_dl = 33; l_TM_db = 47;% levels
        Forces1 = zeros(9,1); % F1, F2, Fhl, Fhb*, Fpls, R1, R2, R3, R4 of first ray of foot
        Forces2 = zeros(10,1); % G1, G2, Fdl, Fdb, Fio, R1, R2, R3, R4, Mlig of second ray of foot
        thetas = zeros(2,4);
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Selection changed function: JointButtonGroup
        function JointButtonGroupSelectionChanged(app, event)
            % plot the free body diagram according to the joint selected
            switch app.JointButtonGroup.SelectedObject.Tag
                case 'IP'
                    app.Model1.ImageSource = '1-IP.png';
                    data(1:4,1) = string(["F1", "Fhl", "||R1||", "θ1"]);
                    data(1:4,2) = string(["force under toe pad", ...
                        "force along tendon of flexor hallucis longus.", ...
                        "magnitude of the resultant force R1", ...
                        "direction of the resultant force R1"]);
                    data(1:4,3) = string([app.Forces1(1)+" N", app.Forces1(3)+" N", app.Forces1(6)+" N", app.thetas(1,1) + "°"]);
                    app.UITable.Data = data;
                    
                case 'MP'
                    app.Model1.ImageSource = '1-MP.png';
                    data(1:5,1) = string(["F1", "Fhl", "Fhb*", "||R2||", "θ2"]);
                    data(1:5,2) = string(["force under toe pad", ...
                        "force along tendon of flexor hallucis longus.", ...
                        "force along tendon of flexor hallucis brevis.", ...
                        "magnitude of the resultant force R2", ...
                        "direction of the resultant force R2"]);
                    data(1:5,3) = string([app.Forces1(1)+" N", app.Forces1(3)+" N", app.Forces1(4)+" N", app.Forces1(7)+" N", app.thetas(1,2) + "°"]);
                    app.UITable.Data = data;
                    
                case 'MTH1'
                    app.Model1.ImageSource = '1-MTH.png';
                    data(1:6,1) = string(["F1", "F2", "Fhl", "Fhb*", "||R3||", "θ3"]);
                    data(1:6,2) = string(["force under toe pad", ...
                        "force under metatarsal head", ...
                        "force along tendon of flexor hallucis longus.", ...
                        "force along tendon of flexor hallucis brevis.", ...
                        "magnitude of the resultant force R3", ...
                        "direction of the resultant force R3"]);
                    data(1:6,3) = string([app.Forces1(1)+" N", app.Forces1(2)+" N", ...
                        app.Forces1(3)+" N", app.Forces1(4)+" N", app.Forces1(8)+" N", app.thetas(1,3) + "°"]);
                    app.UITable.Data = data;
                    
                case 'TM'
                    app.Model1.ImageSource = '1-TM.png';
                    data(1:7,2) = string(["force under toe pad", ...
                        "force under metatarsal head", ...
                        "force along tendon of flexor hallucis longus.", ...
                        "force along tendon of flexor hallucis brevis.", ...
                        "force of peroneus longus in sagittal plane", ...
                        "magnitude of the resultant force R4", ...
                        "direction of the resultant force R4"]);
                    data(1:7,1) = string(["F1", "F2", "Fhl", "Fhb*", "Fpls", "||R4||", "θ4"]);
                    data(1:7,3) = string([app.Forces1(1)+" N", app.Forces1(2)+" N", ...
                        app.Forces1(3)+" N", app.Forces1(4)+" N", app.Forces1(5)+" N", app.Forces1(9)+" N", app.thetas(1,4) + "°"]);
                    app.UITable.Data = data;
            end
        end

        % Selection changed function: JointButtonGroup_2
        function JointButtonGroup_2SelectionChanged(app, event)
            
            % plot the free body diagram according to the joint selected
            switch app.JointButtonGroup_2.SelectedObject.Tag
                case 'DIP'
                    app.Image2_3.ImageSource = '2-DIP.png';
                    data(1:4,2) = string(["force under toe pad", ...
                        "force along tendon of flexor digitorum longus", ...
                        "magnitude of the resultant force R1", ...
                        "direction of the resultant force R1"]);
                    data(1:4,1) = string(["G1", "Fdl", "||R1||", "θ1"]);
                    data(1:4,3) = string([app.Forces2(1)+" N", app.Forces2(3)+" N", app.Forces2(6)+" N", app.thetas(2,1) + "°"]);
                    app.UITable_2.Data = data;
                    
                case 'PIP'
                    app.Image2_3.ImageSource = '2-PIP.png';
                    data(1:5,1) = string(["G1", "Fdl", "Fdb", "||R2||", "θ2"]);
                    data(1:5,2) = string(["force under toe pad", ...
                        "force along tendon of flexor digitorum longus", ...
                        "force along tendon of flexor digitorum brevis", ...
                        "magnitude of the resultant force R2", ...
                        "direction of the resultant force R2"]);
                    data(1:5,3) = string([app.Forces2(1)+" N", app.Forces2(3)+" N", app.Forces2(4)+" N", app.Forces2(7)+" N", app.thetas(2,2) + "°"]);
                    app.UITable_2.Data = data;
                    
                case 'MP'
                    app.Image2_3.ImageSource = '2-MP.png';
                    data(1:6,1) = string(["G1", "Fdl", "Fdb", "Fio", "||R3||", "θ3"]);
                    data(1:6,2) = string(["force under toe pad", ...
                        "force along tendon of flexor digitorum longus", ...
                        "force along tendon of flexor digitorum brevis", ...
                        "force of interossei muscle", ...
                        "magnitude of the resultant force R3", ...
                        "direction of the resultant force R3"]);
                    data(1:6,3) = string([app.Forces2(1)+" N", app.Forces2(3)+" N", app.Forces2(4)+" N", ...
                        app.Forces2(5)+" N", app.Forces2(8)+" N", app.thetas(2,3) + "°"]);
                    app.UITable_2.Data = data;
                    
                case 'MTH2'
                    app.Image2_3.ImageSource = '2-MTH.png';
                    data(1:6,1) = string(["G1", "G2", "Fdl", "Fdb", "||R4||", "θ4"]);
                    data(1:6,2) = string(["force under toe pad", ...
                        "forces under metatarsal head", ...
                        "force along tendon of flexor digitorum longus", ...
                        "force along tendon of flexor digitorum brevis", ...
                        "magnitude of the resultant force R4", ...
                        "direction of the resultant force R4"]);
                   data(1:6,3) = string([app.Forces2(1)+" N", app.Forces2(2)+" N", app.Forces2(3)+" N", ...
                        app.Forces2(4)+" N", app.Forces2(9)+" N", app.thetas(2,4) + "°"]);
                    app.UITable_2.Data = data;
                    
                case 'TM'
                    app.Image2_3.ImageSource = '2-TM.png';
                    data(1:5,1) = string(["G1", "G2", "Fdl", "Fdb", "Mlig"]);
                    data(1:5,2) = string(["force under toe pad", ...
                        "forces under metatarsal head", ...
                        "force along tendon of flexor digitorum longus", ...
                        "force along tendon of flexor digitorum brevis", ...
                        "brating moment by plantar ligaments"]);
                    data(1:5,3) = string([app.Forces2(1)+" N", app.Forces2(2)+" N", app.Forces2(3)+" N", ...
                        app.Forces2(4)+" N", app.Forces2(10)+" Nmm"]);
                    app.UITable_2.Data = data;
            end
            
        end

        % Value changed function: F1Value
        function F1ValueValueChanged(app, event)
            F1 = app.F1Value.Value; % Ground reaction force under the toe pad of the first ray
            F2 = 1.22 * F1; % 1.22: experimental ratio
            app.F2Value.Value = F2;
            x = sym('x');
            function [amp, dir] = vectorSum(f1, f2)
                amp = sqrt(f1^2+f2^2);
                dir = atan2d(f1,f2);
            end
            
            % IP
            Fhl = double(solve(x * (app.r_IP + 1) == F1 * app.distal1, x));
            [R1, theta1] = vectorSum(F1, Fhl);
            
            % MP    
            Fhb = double(solve(x * (app.r_MP1+1) + Fhl * (app.r_MP1+3) == F1 * (app.distal1 + app.proximal1), x));
            [R2, theta2] = vectorSum(F1 - Fhb*sind(app.d_MP_hall) - Fhl*sind(app.d_MP_hall), Fhb*cosd(app.d_MP_hall) + Fhl*cosd(app.d_MP_hall));
            
            %MTH
            [R3, theta3] = vectorSum(F1 + F2 + Fhl*sind(app.d_MTH_hl) + Fhb*sind(app.d_MTH_hb), Fhl*cosd(app.d_MTH_hl) + Fhb*cosd(app.d_MTH_hb));
            
            %TM
            Fpls = double(solve(Fhl * app.l_TM_hl + Fhb * app.l_TM_hb + x * app.l_TM_pls == F2 * (app.meta1*cosd(app.d_meta1)) + F1 * (app.distal1 + app.proximal1 + app.meta1*cosd(app.d_meta1)), x)); 
            [R4, theta4] = vectorSum(F1 + F2 + Fhl*sind(app.d_MTH_hl) + Fhb*sind(app.d_MTH_hb), Fhl*cosd(app.d_MTH_hl) + Fhb*cosd(app.d_MTH_hb) + Fpls);
            
            app.Forces1 = [F1, F2, Fhl, Fhb, Fpls, R1, R2, R3, R4];
            app.thetas(1,:) = [theta1, theta2, theta3, theta4];
            
            JointButtonGroupSelectionChanged(app, event)
        end

        % Value changed function: G1EditField
        function G1EditFieldValueChanged(app, event)
            G1 = app.G1EditField.Value; % Ground reaction force under the toe pad of the second ray
            G2 = 5.66 * G1; % experimental ratio
            app.G2EditField.Value = G2;
            x = sym('x');
            function [amp, dir] = vectorSum(f1, f2)
                amp = sqrt(f1^2+f2^2);
                dir = atan2d(f1,f2);
            end
            
            % DIP
            Fdl = double(solve(x * (app.r_DIP + 1) == G1 * app.distal2, x));
            [R1, theta1] = vectorSum(G1 + Fdl*sind(app.d_DIP_dl), Fdl*cosd(app.d_DIP_dl));
            
            % PIP
            Fdb = double(solve(x*(app.r_PIP + 2) + Fdl*app.r_PIP== G1 *(app.middle2+app.distal2), x));
            [R2, theta2] = vectorSum(G1 + Fdl*sind(app.d_PIP_d) + Fdb*sind(app.d_PIP_d), Fdl*cosd(app.d_PIP_d) + Fdb*cosd(app.d_PIP_d));
            
            % MP
            Fio = double(solve(x*(app.r_MP2 + 1) + Fdl*(app.r_MP2 + 4) + Fdb*(app.r_MP2 + 5)== G1 *(app.proximal2 + app.middle2 + app.distal2), x));
            [R3, theta3] = vectorSum(G1 - Fdl*sind(app.d_MP_d) - Fdb*sind(app.d_MP_d) - Fio*sind(app.d_MP_d), Fdl*cosd(app.d_MP_d) + Fdb*cosd(app.d_MP_d) + Fio*cosd(app.d_MP_d));

            % MTH
            [R4, theta4] = vectorSum(G1 + G2 + Fdl*sind(app.d_MTH_dl) + Fdb*sind(app.d_MTH_db), Fdl*cosd(app.d_MTH_dl) + Fdb*cosd(app.d_MTH_db));
            
            % TM
            Mlig = double(solve(x + Fdl*app.l_TM_dl + Fdb*app.l_TM_db == G2*app.meta2*cosd(app.d_meta2) + G1 *(app.proximal2 + app.middle2 + app.distal2 + app.meta2*cosd(app.d_meta2)), x));
            
            app.Forces2 = [G1, G2, Fdl, Fdb, Fio, R1, R2, R3, R4, Mlig];
            app.thetas(2,:) = [theta1, theta2, theta3, theta4];

            JointButtonGroup_2SelectionChanged(app, event)
        end

        % Value changing function: Spinner_25
        function Spinner_25ValueChanging(app, event)
            changingValue = event.Value;
            app.l_TM_hb = changingValue;
            F1ValueValueChanged(app, event);
        end

        % Value changing function: Spinner_24
        function Spinner_24ValueChanging(app, event)
            changingValue = event.Value;
            app.l_TM_hl = changingValue;
            F1ValueValueChanged(app, event);
        end

        % Value changing function: Spinner_23
        function Spinner_23ValueChanging(app, event)
            changingValue = event.Value;
            app.l_TM_pls = changingValue;
            F1ValueValueChanged(app, event);
        end

        % Value changing function: Spinner_4
        function Spinner_4ValueChanging(app, event)
            changingValue = event.Value;
            app.d_meta1 = changingValue;
            F1ValueValueChanged(app, event);
        end

        % Value changing function: Spinner_18
        function Spinner_18ValueChanging(app, event)
            changingValue = event.Value;
            app.r_MP1 = changingValue;
            F1ValueValueChanged(app, event);
        end

        % Value changing function: Spinner_19
        function Spinner_19ValueChanging(app, event)
            changingValue = event.Value;
            app.r_IP = changingValue;
            F1ValueValueChanged(app, event);
        end

        % Value changing function: Spinner_8
        function Spinner_8ValueChanging(app, event)
            changingValue = event.Value;
            app.meta1 = changingValue;
            F1ValueValueChanged(app, event);
        end

        % Value changing function: Spinner_2
        function Spinner_2ValueChanging(app, event)
            changingValue = event.Value;
            app.proximal1 = changingValue;
            F1ValueValueChanged(app, event);
        end

        % Value changing function: Spinner
        function SpinnerValueChanging(app, event)
            changingValue = event.Value;
            app.distal1 = changingValue;
            F1ValueValueChanged(app, event);
        end

        % Value changing function: Spinner_6
        function Spinner_6ValueChanging(app, event)
            changingValue = event.Value;
            app.d_MP_hall = changingValue;
            F1ValueValueChanged(app, event);
        end

        % Value changing function: Spinner_7
        function Spinner_7ValueChanging(app, event)
            changingValue = event.Value;
            app.d_MTH_hl = changingValue;
            F1ValueValueChanged(app, event);
        end

        % Value changing function: Spinner_26
        function Spinner_26ValueChanging(app, event)
            changingValue = event.Value;
            app.d_MTH_hb = changingValue;
            F1ValueValueChanged(app, event);
        end

        % Value changing function: Spinner_27
        function Spinner_27ValueChanging(app, event)
            changingValue = event.Value;
            app.d_MTH_db = changingValue;
            G1EditFieldValueChanged(app, event);
        end

        % Value changing function: Spinner_29
        function Spinner_29ValueChanging(app, event)
            changingValue = event.Value;
            app.l_TM_dl = changingValue;
            G1EditFieldValueChanged(app, event);
        end

        % Value changing function: Spinner_30
        function Spinner_30ValueChanging(app, event)
            changingValue = event.Value;
            app.d_TM_db = changingValue;
            G1EditFieldValueChanged(app, event);
        end

        % Value changing function: Spinner_14
        function Spinner_14ValueChanging(app, event)
            changingValue = event.Value;
            app.d_MTH_dl = changingValue;
            G1EditFieldValueChanged(app, event);
        end

        % Value changing function: Spinner_13
        function Spinner_13ValueChanging(app, event)
            changingValue = event.Value;
            app.d_meta2 = changingValue;
            G1EditFieldValueChanged(app, event);
        end

        % Value changing function: Spinner_9
        function Spinner_9ValueChanging(app, event)
            changingValue = event.Value;
            app.meta2 = changingValue;
            G1EditFieldValueChanged(app, event);
        end

        % Value changing function: Spinner_16
        function Spinner_16ValueChanging(app, event)
            changingValue = event.Value;
            app.d_MP_d = changingValue;
            G1EditFieldValueChanged(app, event);
        end

        % Value changing function: Spinner_28
        function Spinner_28ValueChanging(app, event)
            changingValue = event.Value;
            app.d_PIP_d = changingValue;
            G1EditFieldValueChanged(app, event);
        end

        % Value changing function: Spinner_17
        function Spinner_17ValueChanging(app, event)
            changingValue = event.Value;
            app.d_DIP_dl = changingValue;
            G1EditFieldValueChanged(app, event);
        end

        % Value changing function: Spinner_20
        function Spinner_20ValueChanging(app, event)
            changingValue = event.Value;
            app.r_MP2 = changingValue;
            G1EditFieldValueChanged(app, event);
        end

        % Value changing function: Spinner_21
        function Spinner_21ValueChanging(app, event)
            changingValue = event.Value;
            app.r_PIP = changingValue;
            G1EditFieldValueChanged(app, event);
        end

        % Value changing function: Spinner_22
        function Spinner_22ValueChanging(app, event)
            changingValue = event.Value;
            app.r_DIP = changingValue;
            G1EditFieldValueChanged(app, event);
        end

        % Value changing function: Spinner_10
        function Spinner_10ValueChanging(app, event)
            changingValue = event.Value;
            app.proximal2 = changingValue;
            G1EditFieldValueChanged(app, event);
        end

        % Value changing function: Spinner_11
        function Spinner_11ValueChanging(app, event)
            changingValue = event.Value;
            app.middle2 = changingValue;
            G1EditFieldValueChanged(app, event);
        end

        % Value changing function: Spinner_12
        function Spinner_12ValueChanging(app, event)
            changingValue = event.Value;
            app.distal2 = changingValue;
            G1EditFieldValueChanged(app, event);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 926 615];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 926 615];

            % Create thefirstrayTab
            app.thefirstrayTab = uitab(app.TabGroup);
            app.thefirstrayTab.Title = 'the first ray';

            % Create Image4
            app.Image4 = uiimage(app.thefirstrayTab);
            app.Image4.Position = [2 203 923 387];
            app.Image4.ImageSource = '0-first.png';

            % Create F1Label
            app.F1Label = uilabel(app.thefirstrayTab);
            app.F1Label.HorizontalAlignment = 'right';
            app.F1Label.FontName = 'Times New Roman';
            app.F1Label.FontSize = 18;
            app.F1Label.Position = [41 136 25 22];
            app.F1Label.Text = 'F1';

            % Create F1Value
            app.F1Value = uieditfield(app.thefirstrayTab, 'numeric');
            app.F1Value.Limits = [0 Inf];
            app.F1Value.ValueDisplayFormat = '%.2f';
            app.F1Value.ValueChangedFcn = createCallbackFcn(app, @F1ValueValueChanged, true);
            app.F1Value.HorizontalAlignment = 'center';
            app.F1Value.FontName = 'Times New Roman';
            app.F1Value.FontSize = 18;
            app.F1Value.Position = [80 135 56 23];

            % Create JointButtonGroup
            app.JointButtonGroup = uibuttongroup(app.thefirstrayTab);
            app.JointButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @JointButtonGroupSelectionChanged, true);
            app.JointButtonGroup.TitlePosition = 'centertop';
            app.JointButtonGroup.Title = 'Joint';
            app.JointButtonGroup.FontName = 'Times New Roman';
            app.JointButtonGroup.FontSize = 18;
            app.JointButtonGroup.Position = [16 13 194 77];

            % Create IPButton
            app.IPButton = uiradiobutton(app.JointButtonGroup);
            app.IPButton.Tag = 'IP';
            app.IPButton.Text = 'IP ';
            app.IPButton.FontName = 'Times New Roman';
            app.IPButton.FontSize = 16;
            app.IPButton.Position = [7 14 70 22];
            app.IPButton.Value = true;

            % Create MPButton
            app.MPButton = uiradiobutton(app.JointButtonGroup);
            app.MPButton.Tag = 'MP';
            app.MPButton.Text = 'MP ';
            app.MPButton.FontName = 'Times New Roman';
            app.MPButton.FontSize = 16;
            app.MPButton.Position = [44 14 78 22];

            % Create TMButton
            app.TMButton = uiradiobutton(app.JointButtonGroup);
            app.TMButton.Tag = 'TM';
            app.TMButton.Text = 'TM ';
            app.TMButton.FontName = 'Times New Roman';
            app.TMButton.FontSize = 16;
            app.TMButton.Position = [147 14 79 22];

            % Create MTHButton
            app.MTHButton = uiradiobutton(app.JointButtonGroup);
            app.MTHButton.Tag = 'MTH1';
            app.MTHButton.Text = 'MTH';
            app.MTHButton.FontName = 'Times New Roman';
            app.MTHButton.FontSize = 16;
            app.MTHButton.Position = [90 14 58 22];

            % Create NLabel_6
            app.NLabel_6 = uilabel(app.thefirstrayTab);
            app.NLabel_6.FontName = 'Times New Roman';
            app.NLabel_6.FontSize = 18;
            app.NLabel_6.Position = [141 101 25 22];
            app.NLabel_6.Text = 'N';

            % Create NLabel_7
            app.NLabel_7 = uilabel(app.thefirstrayTab);
            app.NLabel_7.FontName = 'Times New Roman';
            app.NLabel_7.FontSize = 18;
            app.NLabel_7.Position = [141 137 25 22];
            app.NLabel_7.Text = 'N';

            % Create GroundReactionForceLabel
            app.GroundReactionForceLabel = uilabel(app.thefirstrayTab);
            app.GroundReactionForceLabel.FontName = 'Times New Roman';
            app.GroundReactionForceLabel.FontSize = 18;
            app.GroundReactionForceLabel.Position = [36 171 174 23];
            app.GroundReactionForceLabel.Text = 'Ground Reaction Force';

            % Create F2EditFieldLabel
            app.F2EditFieldLabel = uilabel(app.thefirstrayTab);
            app.F2EditFieldLabel.HorizontalAlignment = 'right';
            app.F2EditFieldLabel.FontName = 'Times New Roman';
            app.F2EditFieldLabel.FontSize = 18;
            app.F2EditFieldLabel.Position = [41 100 25 22];
            app.F2EditFieldLabel.Text = 'F2';

            % Create F2Value
            app.F2Value = uieditfield(app.thefirstrayTab, 'numeric');
            app.F2Value.Limits = [0 Inf];
            app.F2Value.ValueDisplayFormat = '%.2f';
            app.F2Value.Editable = 'off';
            app.F2Value.HorizontalAlignment = 'center';
            app.F2Value.FontName = 'Times New Roman';
            app.F2Value.FontSize = 18;
            app.F2Value.Position = [80 99 56 23];

            % Create Model1
            app.Model1 = uiimage(app.thefirstrayTab);
            app.Model1.Position = [227 -1 259 198];
            app.Model1.ImageSource = '1-IP.png';

            % Create UITable
            app.UITable = uitable(app.thefirstrayTab);
            app.UITable.ColumnName = {'Symbol'; 'Description'; 'Value'; ''};
            app.UITable.RowName = {};
            app.UITable.Position = [508 11 400 186];

            % Create Spinner
            app.Spinner = uispinner(app.thefirstrayTab);
            app.Spinner.ValueChangingFcn = createCallbackFcn(app, @SpinnerValueChanging, true);
            app.Spinner.Position = [827 355 49 22];
            app.Spinner.Value = 20;

            % Create Spinner_2
            app.Spinner_2 = uispinner(app.thefirstrayTab);
            app.Spinner_2.ValueChangingFcn = createCallbackFcn(app, @Spinner_2ValueChanging, true);
            app.Spinner_2.Position = [718 355 49 22];
            app.Spinner_2.Value = 36;

            % Create Spinner_4
            app.Spinner_4 = uispinner(app.thefirstrayTab);
            app.Spinner_4.ValueChangingFcn = createCallbackFcn(app, @Spinner_4ValueChanging, true);
            app.Spinner_4.Position = [515 321 49 22];
            app.Spinner_4.Value = 35;

            % Create Spinner_6
            app.Spinner_6 = uispinner(app.thefirstrayTab);
            app.Spinner_6.ValueChangingFcn = createCallbackFcn(app, @Spinner_6ValueChanging, true);
            app.Spinner_6.Position = [515 209 49 22];
            app.Spinner_6.Value = 12;

            % Create Spinner_7
            app.Spinner_7 = uispinner(app.thefirstrayTab);
            app.Spinner_7.ValueChangingFcn = createCallbackFcn(app, @Spinner_7ValueChanging, true);
            app.Spinner_7.Position = [638 209 49 22];
            app.Spinner_7.Value = 25;

            % Create Spinner_8
            app.Spinner_8 = uispinner(app.thefirstrayTab);
            app.Spinner_8.ValueChangingFcn = createCallbackFcn(app, @Spinner_8ValueChanging, true);
            app.Spinner_8.Position = [579 432 49 22];
            app.Spinner_8.Value = 63;

            % Create Spinner_18
            app.Spinner_18 = uispinner(app.thefirstrayTab);
            app.Spinner_18.ValueChangingFcn = createCallbackFcn(app, @Spinner_18ValueChanging, true);
            app.Spinner_18.Position = [613 317 49 22];
            app.Spinner_18.Value = 13;

            % Create Spinner_19
            app.Spinner_19 = uispinner(app.thefirstrayTab);
            app.Spinner_19.ValueChangingFcn = createCallbackFcn(app, @Spinner_19ValueChanging, true);
            app.Spinner_19.Position = [737 299 49 22];
            app.Spinner_19.Value = 8;

            % Create Spinner_23
            app.Spinner_23 = uispinner(app.thefirstrayTab);
            app.Spinner_23.ValueChangingFcn = createCallbackFcn(app, @Spinner_23ValueChanging, true);
            app.Spinner_23.Position = [384 400 48 22];
            app.Spinner_23.Value = 25;

            % Create Spinner_24
            app.Spinner_24 = uispinner(app.thefirstrayTab);
            app.Spinner_24.ValueChangingFcn = createCallbackFcn(app, @Spinner_24ValueChanging, true);
            app.Spinner_24.Position = [316 399 48 22];
            app.Spinner_24.Value = 34;

            % Create Spinner_25
            app.Spinner_25 = uispinner(app.thefirstrayTab);
            app.Spinner_25.ValueChangingFcn = createCallbackFcn(app, @Spinner_25ValueChanging, true);
            app.Spinner_25.Position = [345 355 48 22];
            app.Spinner_25.Value = 38;

            % Create Spinner_26
            app.Spinner_26 = uispinner(app.thefirstrayTab);
            app.Spinner_26.ValueChangingFcn = createCallbackFcn(app, @Spinner_26ValueChanging, true);
            app.Spinner_26.Position = [796 233 48 22];
            app.Spinner_26.Value = 22;

            % Create thesecondrayTab
            app.thesecondrayTab = uitab(app.TabGroup);
            app.thesecondrayTab.Title = 'the second ray';

            % Create JointButtonGroup_2
            app.JointButtonGroup_2 = uibuttongroup(app.thesecondrayTab);
            app.JointButtonGroup_2.SelectionChangedFcn = createCallbackFcn(app, @JointButtonGroup_2SelectionChanged, true);
            app.JointButtonGroup_2.TitlePosition = 'centertop';
            app.JointButtonGroup_2.Title = 'Joint';
            app.JointButtonGroup_2.FontName = 'Times New Roman';
            app.JointButtonGroup_2.FontSize = 18;
            app.JointButtonGroup_2.Position = [23 26 199 95];

            % Create DIPButton
            app.DIPButton = uiradiobutton(app.JointButtonGroup_2);
            app.DIPButton.Tag = 'DIP';
            app.DIPButton.Text = 'DIP';
            app.DIPButton.FontName = 'Times New Roman';
            app.DIPButton.FontSize = 16;
            app.DIPButton.Position = [7 41 48 22];
            app.DIPButton.Value = true;

            % Create MPButton_2
            app.MPButton_2 = uiradiobutton(app.JointButtonGroup_2);
            app.MPButton_2.Tag = 'MP';
            app.MPButton_2.Text = 'MP';
            app.MPButton_2.FontName = 'Times New Roman';
            app.MPButton_2.FontSize = 16;
            app.MPButton_2.Position = [122 41 78 22];

            % Create TMButton_2
            app.TMButton_2 = uiradiobutton(app.JointButtonGroup_2);
            app.TMButton_2.Tag = 'TM';
            app.TMButton_2.Text = 'TM ';
            app.TMButton_2.FontName = 'Times New Roman';
            app.TMButton_2.FontSize = 16;
            app.TMButton_2.Position = [73 13 79 22];

            % Create MTHButton_2
            app.MTHButton_2 = uiradiobutton(app.JointButtonGroup_2);
            app.MTHButton_2.Tag = 'MTH2';
            app.MTHButton_2.Text = 'MTH';
            app.MTHButton_2.FontName = 'Times New Roman';
            app.MTHButton_2.FontSize = 16;
            app.MTHButton_2.Position = [6 13 58 22];

            % Create PIPButton
            app.PIPButton = uiradiobutton(app.JointButtonGroup_2);
            app.PIPButton.Tag = 'PIP';
            app.PIPButton.Text = 'PIP ';
            app.PIPButton.FontName = 'Times New Roman';
            app.PIPButton.FontSize = 16;
            app.PIPButton.Position = [65 41 49 22];

            % Create G1EditField
            app.G1EditField = uieditfield(app.thesecondrayTab, 'numeric');
            app.G1EditField.Limits = [0 Inf];
            app.G1EditField.ValueDisplayFormat = '%.2f';
            app.G1EditField.ValueChangedFcn = createCallbackFcn(app, @G1EditFieldValueChanged, true);
            app.G1EditField.HorizontalAlignment = 'center';
            app.G1EditField.FontName = 'Times New Roman';
            app.G1EditField.FontSize = 18;
            app.G1EditField.Position = [75 167 56 23];

            % Create G1EditFieldLabel
            app.G1EditFieldLabel = uilabel(app.thesecondrayTab);
            app.G1EditFieldLabel.HorizontalAlignment = 'right';
            app.G1EditFieldLabel.FontName = 'Times New Roman';
            app.G1EditFieldLabel.FontSize = 18;
            app.G1EditFieldLabel.Position = [34 168 27 22];
            app.G1EditFieldLabel.Text = 'G1';

            % Create NLabel_8
            app.NLabel_8 = uilabel(app.thesecondrayTab);
            app.NLabel_8.FontName = 'Times New Roman';
            app.NLabel_8.FontSize = 18;
            app.NLabel_8.Position = [136 131 25 22];
            app.NLabel_8.Text = 'N';

            % Create NLabel_9
            app.NLabel_9 = uilabel(app.thesecondrayTab);
            app.NLabel_9.FontName = 'Times New Roman';
            app.NLabel_9.FontSize = 18;
            app.NLabel_9.Position = [136 169 25 22];
            app.NLabel_9.Text = 'N';

            % Create GroundReactionForceLabel_2
            app.GroundReactionForceLabel_2 = uilabel(app.thesecondrayTab);
            app.GroundReactionForceLabel_2.FontName = 'Times New Roman';
            app.GroundReactionForceLabel_2.FontSize = 18;
            app.GroundReactionForceLabel_2.Position = [26 199 174 23];
            app.GroundReactionForceLabel_2.Text = 'Ground Reaction Force';

            % Create G2EditFieldLabel
            app.G2EditFieldLabel = uilabel(app.thesecondrayTab);
            app.G2EditFieldLabel.HorizontalAlignment = 'right';
            app.G2EditFieldLabel.FontName = 'Times New Roman';
            app.G2EditFieldLabel.FontSize = 18;
            app.G2EditFieldLabel.Position = [34 131 27 22];
            app.G2EditFieldLabel.Text = 'G2';

            % Create G2EditField
            app.G2EditField = uieditfield(app.thesecondrayTab, 'numeric');
            app.G2EditField.Limits = [0 Inf];
            app.G2EditField.ValueDisplayFormat = '%.2f';
            app.G2EditField.Editable = 'off';
            app.G2EditField.HorizontalAlignment = 'center';
            app.G2EditField.FontName = 'Times New Roman';
            app.G2EditField.FontSize = 18;
            app.G2EditField.Position = [75 130 56 23];

            % Create Image2_3
            app.Image2_3 = uiimage(app.thesecondrayTab);
            app.Image2_3.Position = [204 26 385 205];
            app.Image2_3.ImageSource = '2-DIP.png';

            % Create UITable_2
            app.UITable_2 = uitable(app.thesecondrayTab);
            app.UITable_2.ColumnName = {'Symbol'; 'Description'; 'Value'; ''};
            app.UITable_2.RowName = {};
            app.UITable_2.Position = [555 27 343 204];

            % Create Image4_2
            app.Image4_2 = uiimage(app.thesecondrayTab);
            app.Image4_2.Position = [0 237 923 347];
            app.Image4_2.ImageSource = '0-second.png';

            % Create Spinner_9
            app.Spinner_9 = uispinner(app.thesecondrayTab);
            app.Spinner_9.ValueChangingFcn = createCallbackFcn(app, @Spinner_9ValueChanging, true);
            app.Spinner_9.Position = [555 445 49 22];
            app.Spinner_9.Value = 76;

            % Create Spinner_10
            app.Spinner_10 = uispinner(app.thesecondrayTab);
            app.Spinner_10.ValueChangingFcn = createCallbackFcn(app, @Spinner_10ValueChanging, true);
            app.Spinner_10.Position = [670 355 49 22];
            app.Spinner_10.Value = 29;

            % Create Spinner_11
            app.Spinner_11 = uispinner(app.thesecondrayTab);
            app.Spinner_11.ValueChangingFcn = createCallbackFcn(app, @Spinner_11ValueChanging, true);
            app.Spinner_11.Position = [727 359 49 22];
            app.Spinner_11.Value = 15;

            % Create Spinner_12
            app.Spinner_12 = uispinner(app.thesecondrayTab);
            app.Spinner_12.ValueChangingFcn = createCallbackFcn(app, @Spinner_12ValueChanging, true);
            app.Spinner_12.Position = [779 359 49 22];
            app.Spinner_12.Value = 7;

            % Create Spinner_13
            app.Spinner_13 = uispinner(app.thesecondrayTab);
            app.Spinner_13.ValueChangingFcn = createCallbackFcn(app, @Spinner_13ValueChanging, true);
            app.Spinner_13.Position = [455 359 49 22];
            app.Spinner_13.Value = 38;

            % Create Spinner_14
            app.Spinner_14 = uispinner(app.thesecondrayTab);
            app.Spinner_14.ValueChangingFcn = createCallbackFcn(app, @Spinner_14ValueChanging, true);
            app.Spinner_14.Position = [344 342 49 22];
            app.Spinner_14.Value = 26;

            % Create Spinner_16
            app.Spinner_16 = uispinner(app.thesecondrayTab);
            app.Spinner_16.ValueChangingFcn = createCallbackFcn(app, @Spinner_16ValueChanging, true);
            app.Spinner_16.Position = [533 254 49 22];
            app.Spinner_16.Value = 10;

            % Create Spinner_17
            app.Spinner_17 = uispinner(app.thesecondrayTab);
            app.Spinner_17.ValueChangingFcn = createCallbackFcn(app, @Spinner_17ValueChanging, true);
            app.Spinner_17.Position = [718 266 49 22];
            app.Spinner_17.Value = 14;

            % Create Spinner_20
            app.Spinner_20 = uispinner(app.thesecondrayTab);
            app.Spinner_20.ValueChangingFcn = createCallbackFcn(app, @Spinner_20ValueChanging, true);
            app.Spinner_20.Position = [576 334 49 22];
            app.Spinner_20.Value = 7;

            % Create Spinner_21
            app.Spinner_21 = uispinner(app.thesecondrayTab);
            app.Spinner_21.ValueChangingFcn = createCallbackFcn(app, @Spinner_21ValueChanging, true);
            app.Spinner_21.Position = [671 311 40 22];
            app.Spinner_21.Value = 4;

            % Create Spinner_22
            app.Spinner_22 = uispinner(app.thesecondrayTab);
            app.Spinner_22.ValueChangingFcn = createCallbackFcn(app, @Spinner_22ValueChanging, true);
            app.Spinner_22.Position = [727 305 38 22];
            app.Spinner_22.Value = 3;

            % Create Spinner_27
            app.Spinner_27 = uispinner(app.thesecondrayTab);
            app.Spinner_27.ValueChangingFcn = createCallbackFcn(app, @Spinner_27ValueChanging, true);
            app.Spinner_27.Position = [224 290 49 22];
            app.Spinner_27.Value = 16;

            % Create Spinner_28
            app.Spinner_28 = uispinner(app.thesecondrayTab);
            app.Spinner_28.ValueChangingFcn = createCallbackFcn(app, @Spinner_28ValueChanging, true);
            app.Spinner_28.Position = [849 275 49 22];
            app.Spinner_28.Value = 10;

            % Create Spinner_29
            app.Spinner_29 = uispinner(app.thesecondrayTab);
            app.Spinner_29.ValueChangingFcn = createCallbackFcn(app, @Spinner_29ValueChanging, true);
            app.Spinner_29.Position = [287 432 49 22];
            app.Spinner_29.Value = 33;

            % Create Spinner_30
            app.Spinner_30 = uispinner(app.thesecondrayTab);
            app.Spinner_30.ValueChangingFcn = createCallbackFcn(app, @Spinner_30ValueChanging, true);
            app.Spinner_30.Position = [316 363 49 22];
            app.Spinner_30.Value = 47;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = forefoot_force_calculator_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
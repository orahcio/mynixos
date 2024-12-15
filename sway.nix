{ config, lib, pkgs, ...}:
{
	wayland.windowManager.sway = {
    enable = true;
		wrapperFeatures.gtk = true;
		config = rec {
      modifier = "Mod4";
      terminal = "kitty"; 
			menu = "${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu -b | ${pkgs.findutils}/bin/xargs swaymsg exec --";
			defaultWorkspace = "workspace number 1:  ";
			input = {
				"*".xkb_layout = "br";
				"1739:32382:DELL0828:00_06CB:7E7E_Touchpad" = { #"2:7:SynPS/2_Synaptics_TouchPad" = {
					dwt = "enabled";
       		tap = "enabled";
       		natural_scroll = "enabled";
       		middle_emulation = "enabled";
				};
			};
			output = {
				eDP-1.resolution = "1920x1080@60.049Hz";
				HDMI-A-1 = {
					resolution = "1920x1080";
					position = "1920,0";
				};
			};
			seat."*" = { xcursor_theme = "Posy_Cursor_Black 64"; };
			gaps = {
				top = 5;
			};
			floating.criteria = [
				{ app_id = "pavucontrol"; }
				{ app_id = "mpv"; }
			];
			window.commands = [
				{ command = "border none"; criteria.app_id = "mpv"; }
				{ command = "resize set width 350";	criteria.app_id = "mpv"; }
				{ command = "sticky enable";	criteria.app_id = "mpv"; }
				{ command = "move absolute position 1550 850";	criteria.app_id = "mpv"; }
			];
			keybindings =
				let
					mod4 = config.wayland.windowManager.sway.config.modifier;
					wp1 = "number 1:  ";
					wp2 = "number 2:  ";
					wp3 = "number 3:  ";
					wp4 = "number 4:  ";
					wp5 = "number 5:  ";
				in lib.mkOptionDefault {
						"${mod4}+Shift+Return" = "exec qutebrowser";
						"${mod4}+1" = "workspace ${wp1}";
						"${mod4}+2" = "workspace ${wp2}";
						"${mod4}+3" = "workspace ${wp3}";
						"${mod4}+4" = "workspace ${wp4}";
						"${mod4}+5" = "workspace ${wp5}";
						"${mod4}+Shift+1" = "move container to workspace ${wp1}";
						"${mod4}+Shift+2" = "move container to workspace ${wp2}";
						"${mod4}+Shift+3" = "move container to workspace ${wp3}";
						"${mod4}+Shift+4" = "move container to workspace ${wp4}";
						"${mod4}+Shift+5" = "move container to workspace ${wp5}";
						"Print" = "exec grim -o eDP-1";
						"${mod4}+Print" = "exec grim -g \"$(slurp)\" - | swappy -f - | wl-copy";
				};
			startup = [
				{ command = "nm-applet"; }
				{ command = "wpaperd -d"; always = true; }
				{ command = "mako"; always = true; }
				{ command = "kdeconnect-indicator"; }
				# Para compartilhar a tela numa chamada
				{ command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway"; }
				# { command = "swayidle -w timeout 600 \'swaymsg \"output * power off\"\' resume \'swaymsg \"output * power on\"\'"; }
			];
			bars = [
				{
					command = "${pkgs.waybar}/bin/waybar";
					# mode = "dock";
					# statusCommand = "${pkgs.i3status}/bin/i3status";
					# trayOutput = "*";
					# fonts = {
					# 	names = [ "FontAwesome" "FiraCode Nerd Font Mono Ret" ];
					# 	size = 9.0;
					# };
				}
			];
		};
	};

	services.swayidle = {
		enable = true;
		timeouts = [
			{ timeout = 600; command = "swaymsg \"output * power off\""; resumeCommand = "swaymsg \"output * power on\""; }
		];
	};
	
	# Temperatura da cor
	services.gammastep = {
    enable = true;
    # provider = "geoclue2";
		# Coordenadas para Amargosa
		latitude = -13.03;
		longitude = -39.59;
		tray = true;
	};

	# Waybar
	programs.waybar = {
		enable = true;
		settings = [
			{
				"height" = 31;
				"spacing" = 5;
				"margin-top" = 27;
				"margin-left" = 15;
				"margin-right" = 15;
				"modules-left" = [
        	"sway/workspaces"
        	"sway/mode"
        	"sway/scratchpad"
    		];
				"modules-center" = [
	        "sway/window"
    		];
				"modules-right" = [
        	"pulseaudio"
					"memory"
					"disk"
					"backlight"
					"battery"
					"clock"
        	"tray"
					"custom/power"
    		];
				"sway/mode" = {
					"format" = "<span style=\"italic\">{}</span>";
				};
				"sway/scratchpad" = {
					"format" = "{icon} {count}";
					"show-empty" = false;
					"format-icons" = ["" ""];
					"tooltip" = true;
					"tooltip-format" = "{app}: {title}";
				};
				"pulseaudio" = {
					"format" = "{volume}% {icon} {format_source}";
        	"format-bluetooth" = "{volume}% {icon} {format_source}";
        	"format-bluetooth-muted" = " {icon} {format_source}";
        	"format-muted" = " {format_source}";
        	"format-source" = "{volume}% ";
        	"format-source-muted" = "";
        	"format-icons" = {
						"headphone" = "";
            "hands-free" = " ";
            "headset" = " ";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" =["" "" ""];
        	};
        	"on-click" = "pavucontrol";
				};
				"memory" = {
					"format" = "{avail:.1f}G ";
					"unit" = "GB";
				};
				"disk" = {
					"format" = "{free} ";
					"unit" = "GB";
				};
				"backlight" = {
					# "device": "acpi_video1",
					"format" = "{percent}% {icon}";
					"format-icons" = ["" "" "" "" "" "" "" "" ""];
				};
				"battery" = {
					"states" = {
						"goog" = 95;
						"warning" = 30;
						"critical" = 15;
					};
					"format" = "{capacity}% {icon}";
					"format-full" = "{capacity}% {icon}";
					"format-charging" = "{capacity}%  ";
					"format-plugged" = "{capacity}%  ";
					"format-alt" = "{time} {icon}";
					"format-icons" = ["" "" "" "" ""];
				};
				"clock" = {
					"timezone" = "America/Bahia";
					"format" = "{:L%a. %d %b. %Y %H:%M}";
					"tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
					"on-click" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
					"format-alt" = "{%d-%m-%Y}";
				};
				"custom/power" = {
        	"format" = "⏻ ";
					"tooltip" = false;
					"menu" = "on-click";
					"menu-file" = "$HOME/.config/waybar/power_menu.xml"; # Menu file in resources folder
					"menu-actions" = {
						"shutdown" = "shutdown";
						"reboot" = "reboot";
						"suspend" = "systemctl suspend";
						"hibernate" = "systemctl hibernate";
					};
				};
			}
		];
	};


}

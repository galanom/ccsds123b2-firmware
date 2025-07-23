DTSI_IN="pl.dtsi"
FW_NAME=$(grep "firmware-name" ${DTSI_IN} | awk -F'"' '/firmware-name/ { print $2 }')
DTSI_OUT="${FW_NAME%%.*}.dtsi"
# first fragment for fpga_full
#"/dts-v1/;\n/plugin/;\n/ {\n\tfragment@0 {\n\t\ttarget = <&fpga_full>;\n\t\toverlay0: __overlay__ {\n\t\t\tfirmware-name = \"${fw}\";\n\t\t};\n\t};\n"

nodes=""
for node in "clocking" "afi" "ccsds123b2_"; do
	nodes="${nodes}$(sed -n "/${node}[0-9]*:/ { :a; N; /};/!ba; p }" "${DTSI_IN}" | sed $'s/^/\t/')"$'\n'
done

cat <<EOF > ${DTSI_OUT}
/dts-v1/;
/plugin/;

/ {
	fragment@0 {
		target = <&fpga_full>;
		overlay0: __overlay__ {
			firmware-name = "${FW_NAME}";
		};
	};

	fragment@1 {
		target = <&axi>;
		overlay1: __overlay__ {
${nodes}
		};
	};
};
EOF




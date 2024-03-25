/*
Demonstrate how you can create a json file
*/
package main

import "base:builtin"
import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:runtime"
import "core:strings"

main :: proc() {
	fmt.println("Odin builtin constants")

	path: string
	if len(os.args) > 1 {
		path = os.args[1]
	} else {
		path = "odin_info.json"
	}

	b := strings.builder_make()
	defer strings.builder_destroy(&b)

	info: struct {
		ODIN_OS:      runtime.Odin_OS_Type,
		ODIN_ARCH:    runtime.Odin_Arch_Type,
		ODIN_ENDIAN:  runtime.Odin_Endian_Type,
		ODIN_VENDOR:  string,
		ODIN_VERSION: string,
		ODIN_ROOT:    string,
		ODIN_DEBUG:   bool,
	} = {ODIN_OS, ODIN_ARCH, ODIN_ENDIAN, ODIN_VENDOR, ODIN_VERSION, ODIN_ROOT, ODIN_DEBUG}

	fmt.println("Odin")
	fmt.printfln("%#v", info)

	fmt.println("Json")
	mo: json.Marshal_Options = {
		pretty         = true,
		use_enum_names = true,
	}
	err := json.marshal_to_builder(&b, info, &mo)
	assert(err == json.Marshal_Data_Error.None)
	json_data: []u8
	if len(b.buf) != 0 {
		json_data = b.buf[:]
		fmt.printfln("%s", json_data)
		fmt.printfln("Writing: %s", path)
		ok := os.write_entire_file(path, json_data)
		if !ok {fmt.eprintln("Unable to write file")}
	}

	fmt.println("Done.")
}

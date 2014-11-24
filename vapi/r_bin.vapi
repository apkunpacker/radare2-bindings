/* radare - LGPL - Copyright 2009-2013 - nibble */

namespace Radare {
	[Compact]
	[CCode (cheader_filename="r_bin.h,r_list.h,r_types_base.h", cname="RBin", free_function="r_bin_free", cprefix="r_bin_")]
	public class RBin {
		[CCode (cprefix="R_BIN_SYM_")]
		public enum Sym {
			ENTRY,
			INIT,
			MAIN,
			FINI,
			LAST
		}
		public unowned string file;
		public RBin.File cur;
		public int narch;

		public RBin();
		public void iobind (RIO io);

		public uint64 wr_scn_resize (string name, uint64 size);
		public int wr_rpath_del ();
		public int wr_output (string filename);

		public int load(string file, uint64 baddr, uint64 laddr, int xtr_idx, int fd, int rawstr);
		public RBuffer create(uint8 *code, int codelen, uint8 *data, int datalen);
		public int use_arch(string arch, int bits, string name);
		public int select(string arch, int bits, string name);
		public int select_idx(string? name, int idx);
		public int list();
		public uint64 get_baddr();
		public RBin.Addr get_sym(int sym); // XXX: use RBin.Sym here ?
		public unowned RList<unowned RBin.Addr> get_entries();
		public unowned RList<unowned RBin.Field> get_fields();
		public unowned RList<unowned RBin.Import> get_imports();
		public unowned RList<unowned RBin.Section> get_sections();
		public unowned RList<unowned RBin.String> get_strings();
		public unowned RList<unowned RBin.Symbol> get_symbols();
		public unowned RList<unowned RBin.Reloc> get_relocs();
		public unowned RList<unowned string> get_libs();
		public unowned RBin.Info get_info();
		public int is_big_endian();
		public int is_stripped();
		public int is_static();
		public int has_dbg_linenums();
		public int has_dbg_syms();
		public int has_dbg_relocs();
		public int addr2line(uint64 addr, ref string file, int len, out int line);
		public string addr2text(uint64 addr);
		public RBin.Object get_object ();

		[Compact]
		[CCode (cname="RBinFile", free_function="", ref_function="", unref_function="")]
		public class File {
			RBuffer buf;
			public unowned string file;
			public int size;
			public uint64 offset;
			public RBin.Object o;
			public Plugin curplugin;
		}

		[CCode (cname="RBinPlugin", free_function="", ref_function="", unref_function="")]
		public class Plugin {
		}

		[CCode (cname="RBinDwarfRow", free_function="", ref_function="", unref_function="")]
		public class DwarfRow {
			public uint64 address;
			public string file;
			public int line;
			public int column;
		}

		[CCode (cname="RBinClass", free_function="", ref_function="", unref_function="")]
		public class Class {
			public string name;
			public string super;
			public int index;
			public RList<Symbol> methods;
			public RList<Field> fields;
			public bool visibility;
		}

		[CCode (cname="RBinObject", free_function="", ref_function="", unref_function="")]
		public class Object {
			public uint64 baddr;
			public int size;
			public RList<RBin.Section> sections;
			public RList<RBin.Import> imports;
			public RList<RBin.Symbol> symbols;
			//public RList<RBin.Symbol> entries;
			public RList<RBin.Addr> entries;
			public RList<RBin.Field> fields;
			public RList<RBin.Symbol> libs;
			public RList<RBin.Reloc> relocs;
			public RList<RBin.String> strings;
			public RList<RBin.Class> classes;
			public RList<RBin.DwarfRow> lines;
			public RBin.Info info;
			public RBin.Addr binsym[4]; //
		}

		[CCode (cname="RBinAddr", free_function="", ref_function="", unref_function="")]
		public class Addr {
			public uint64 vaddr;
			public uint64 paddr;
		}

		[CCode (cname="RBinSection", free_function="", ref_function="", unref_function="")]
		public class Section {
			public char name[512]; // FIXME proper static strings w/o hardcoded size
			public uint64 size;
			public uint64 vsize;
			public uint64 vaddr;
			public uint64 paddr;
			public uint64 srwx;
		}

		[CCode (cname="RBinSymbol", free_function="", ref_function="", unref_function="")]
		public class Symbol {
			public char name[512]; // FIXME proper static strings w/o hardcoded size
			public char forwarder[512]; // FIXME proper static strings w/o hardcoded size
			public char bind[512]; // FIXME proper static strings w/o hardcoded size
			public char type[512]; // FIXME proper static strings w/o hardcoded size
			public char classname[512]; // FIXME proper static strings w/o hardcoded size
			public char descriptor[512]; // FIXME proper static strings w/o hardcoded size
			public uint64 vaddr;
			public uint64 paddr;
			public uint64 size;
			public uint64 ordinal;
		}

		[CCode (cname="RBinImport", free_function="", ref_function="", unref_function="")]
		public class Import {
			public char name[512]; // FIXME proper static strings w/o hardcoded size
			public char bind[512]; // FIXME proper static strings w/o hardcoded size
			public char type[512]; // FIXME proper static strings w/o hardcoded size
			public char classname[512]; // FIXME proper static strings w/o hardcoded size
			public char descriptor[512]; // FIXME proper static strings w/o hardcoded size
			public uint64 ordinal;
		}


		[CCode (cprefix="R_BIN_RELOC")]
		public enum RelocType {
			_8,
			_16,
			_32,
			_64
		}
		[CCode (cname="RBinReloc", free_function="", ref_function="", unref_function="")]
		public class Reloc {
			public uint8 type;
			public uint8 additive;
			public RBin.Symbol symbol;
			public RBin.Import import;
			public int64 addend;
			public uint64 vaddr;
			public uint64 paddr;
			public uint32 visibility;
		}

		[CCode (cname="RBinInfo", free_function="", ref_function="", unref_function="")]
		public class Info {
			public char file[512]; // FIXME proper static strings w/o hardcoded size
			public char type[512]; // FIXME proper static strings w/o hardcoded size
			public char bclass[512]; // FIXME proper static strings w/o hardcoded size
			public char rclass[512]; // FIXME proper static strings w/o hardcoded size
			public char arch[512]; // FIXME proper static strings w/o hardcoded size
			public char machine[512]; // FIXME proper static strings w/o hardcoded size
			public char os[512]; // FIXME proper static strings w/o hardcoded size
			public char subsystem[512]; // FIXME proper static strings w/o hardcoded size
			public char rpath[512]; // FIXME proper static strings w/o hardcoded size
			public unowned string lang;
			public int bits;
			public bool has_va;
			public bool has_pi;
			public bool big_endian;
			public uint64 dbg_info;
		}

		[CCode (cname="RBinString", free_function="", ref_function="", unref_function="")]
		public class String {
			public char @string[512]; // FIXME proper static strings w/o hardcoded size
			public uint64 vaddr;
			public uint64 paddr;
			public uint64 ordinal;
			public uint64 size;
		}

		[CCode (cname="RBinField", free_function="", ref_function="", unref_function="")]
		public class Field {
			public char name[512]; // FIXME proper static strings w/o hardcoded size
			public uint64 vaddr;
			public uint64 paddr;
		}
	}
}

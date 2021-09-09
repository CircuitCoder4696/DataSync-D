module data.data_struct.StructUtils;
import core.data.DataUtils;
import core.stdc.stdlib:malloc;
import std.algorithm:canFind;
import std.stdio:writeln;
import std.meta:AliasSeq;
import std.traits:FieldNameTuple,fullyQualifiedName;

template tupleFuncs(alias func, args...) {

};

alias data_t= void[];

public static void[] allocate(size_t size) {
	return new void[size];
};

public struct test {
	int x;
	int y;
	data_t a;
	data_t b;
	int z;
	ulong[2] fake_data= [4,8];
    data_t data;
};

struct slice_t {
	size_t parrentTypePtr,index,refOffset,refSize,ptr,offset,size;
	string name;
	public void[] data() @property {
		size_t p_00= (cast(size_t) this.parrentTypePtr) + this.refOffset;
		void* p_01= cast(void*) p_00;
		return (this.ptr).asPtr[0..(this.size)];
	};
	public void* refPtr() @property {
		size_t p_00= this.parrentTypePtr + this.refOffset;
		void* p_01= cast(void*) p_00;
		return p_01;
	};
	public bool isVarSizeArray() @property {
		size_t p_00= (cast(size_t) this.parrentTypePtr) + this.ptr;
		return p_00 > this.ptr;
	};
	public bool isInDataStruct() @property {
		return (this.parrentTypePtr + this.refOffset) == this.ptr;
	};
    public void setSliceOffset(size_t newOffset) {
        this.refOffset= newOffset;
    };
    public void[] dataPtrAsData() {
		return (cast(void*) (this.parrentTypePtr + this.refOffset + 8))[0..8];
    };
    public void[] dataOffsetAsData() {
		return ((cast(void*) (this.parrentTypePtr + this.refOffset + 8)).numVal - this.parrentTypePtr).asPtr[0..8];
    };
    public void* dataOffsetAsPtr() {
		return ((cast(void*) (this.parrentTypePtr + this.refOffset + 8)).numVal - this.parrentTypePtr).asPtr;
    };
    public void setOffset(size_t newOffset) {
		long change= newOffset - this.offset;
		this.ptr += change;
		this.offset += change;
	};
};

struct struct_t(T) {
    slice_t[] arrays;
	T dataStructure;
};

public static slice_t[] getDataBodyReferences(T)(ref T data) {    // Do Not Edit!
	// Thanks to AntonC#3545-296666311688454144:   This function for variable-size structures can now iterate through a struct's fields.
	import std.conv:to;
	import hex;
	slice_t[] d_00,d_01;
	size_t this_ptr= cast(size_t) &data;
	string[] nl= [];
	foreach(n; FieldNameTuple!(typeof(data)))
		nl ~= n;
	foreach(i, ref v; data.tupleof) static if(is(typeof(v) vi : vi[])) {
		d_00 ~= [slice_t(
			this_ptr,                                         //   slice_t.parrentTypePtr
			i,                                                //   slice_t.index
			(cast(size_t) &v) - this_ptr,                     //   slice_t.refOffset
			v.sizeof,                                         //   slice_t.refSize
			(cast(size_t) v.ptr),                             //   slice_t.ptr
			((cast(size_t) v.ptr) - this_ptr).asPtr.numVal,   //   slice_t.offset
			v.length,                                         //   slice_t.size
			nl[i])];                                          //   slice_t.name
	};
	foreach(i, v; d_00) if(v.isVarSizeArray()) {
		d_01 ~= [v];
	};
	return d_01;
};

public static void[][] getDataBody(T)(T data) {
	import hex;    //   Remove once library is developed.  
	void[][] result= [];
	foreach(i, v; getDataBodyReferences(data)) {
		result ~= [v.data];
	};
	return result;
};

public static void[] getData(T)(T data) {
	import hex;    //   Remove once library is developed.
	void[] result= [];
    slice_t[] d_00= getDataBodyReferences(data);
	foreach(i, v; d_00) {
		result ~= v.data;
		v.setOffset(result.length);
		writeln("-----");
		writeln("Array number ",i," at data-pointer:   ",v.offset.asPtr.numVal.asHex," ",v.offset.asPtr.numVal.asHexString);
		writeln((v.ptr).asPtr[0..(v.size)].asHexString);
	};
	return ((cast(void*) &data)[0..(typeof(data).sizeof)])~result;
};

public static void[] _dsEncode(T)(T data) {
    size_t headSize,bodySize,size;
    headSize= tyepof(data).sizeof;
	auto al_00= getDataBodyReferences(data);
};

public static void data(void* data) {
		import std.file;
		write("./data",data[0..0x00003000]);
};

public void main(string[] ArgV) {
        pragma(msg,"This is currently experimental, and has bugs in it.  Suggestions for overcoming bugs are welcome.  ");
	import core.data.DataUtils;
	import hex;
	// test1 d_00= test1(1, 2, allocate(40), allocate(40), 40, allocate(40));
	auto d_02= test(
        7,
        2,
        "asdf".voidArr,
        "Hi world.  ".voidArr,
        40,
        [4,5],
        "Hello world.  ".voidArr,
    );
	auto d_03= getDataBody(d_02);
    auto d_04= getData(d_02);
	writeln("-----");
    writeln(d_04.asHexString);
	writeln("-----");
    writeln(d_02.sizeof);
	// data(&d_02);
};

module data.data_struct.DataStruct;
import core.stdc.stdlib:malloc;
import std.stdio:writeln;
import std.traits:FieldNameTuple,fullyQualifiedName;

public struct data_t {
	ulong offset;
	ulong size;
	public static data_t allocate(ulong size) {
		data_t* result= cast(data_t*)malloc(data_t.sizeof + size);
		return result[0];
	};
};

public struct data_ni {
	ulong index;
	string name;
};

public struct test {
	int x;
	int y;
	data_t a;
	data_t b;
	int z;
	data_t data;
	ulong[2] fake_data= [4,8];
};

public data_ni[] dataNamedIndexs(T)(T data) {
	string dt= fullyQualifiedName!(typeof(data_t.allocate(0)));
	writeln(dt);
	data_te[] result= [];
	enum d_00_i= FieldNameTuple!(typeof(data));
	static foreach(i, v; d_00_i) static if(v!="") if(dt == fullyQualifiedName!(typeof(mixin("data."~v)))) try {
		result ~= [data_ni(i, "data."~v)];
	} catch(Exception ex) {};
	return result;
};

public ulong[] dataIndexes(T)(T data) {
	string dt= fullyQualifiedName!(typeof(data_t.allocate(0)));
	writeln(dt);
	ulong[] result= [];
	enum d_00_i= FieldNameTuple!(typeof(data));
	static foreach(i, v; d_00_i) static if(v!="") if(dt == fullyQualifiedName!(typeof(mixin("data."~v)))) try {
		result ~= [i];
	} catch(Exception ex) {};
	return result;
};

public ulong[] asdf(T)(T data) {
	import std.format:format;
	ulong[] result= [];
	ulong[] indexes= dataIndexes(data);
	auto values= data.tupleof;
	static foreach(ii, i; [2, 3, 5]) try {
		writeln(mixin("data.tupleof[%s]".format(i)));
	} catch(Exception ex) {};
	return result;
};

public size_t bodySize(test data) {
	string dt= fullyQualifiedName!(typeof(data_t.allocate(0)));
	enum di= FieldNameTuple!(typeof(data));
	size_t result;
	writeln(di);
	writeln("/-----");
	enum indecies= [];
	static foreach(i, fn; di) {
		writeln(di[i], ":", fullyQualifiedName!(typeof(mixin("data."~fn))), "= ", mixin("data."~fn));
	};
	writeln("\\-----");
	return result;
};

public size_t structDup(test data) {
	string dt= fullyQualifiedName!(typeof(data_t.allocate(0)));
	enum di= FieldNameTuple!(typeof(data));
	size_t result;
	writeln(di);
	writeln("/-----");
	enum indecies= [];
	static foreach(i, fn; di) {
		writeln(" ", fullyQualifiedName!(typeof(mixin("data."~fn))), di[i], "= ", mixin("data."~fn));
	};
	writeln("\\-----");
	return result;
};

public void[] encode08(T)(T data) {
	data_t dt= data_t.allocate(0);
	size_t size= data.length * typeof(data[0]).sizeof;
	void[] d_02= (cast(void*) data[].ptr)[0..(size)];
	test* d_00= new test(data_t.allocate(size));
	void[] result= malloc(size + test.sizeof)[0..(size + test.sizeof)];
	result[0..(test.sizeof)]= (cast(void*) d_00)[0..(test.sizeof)];
	result[(test.sizeof)..$]= d_02;
	enum d_00_i= FieldNameTuple!(test);
	static foreach(i, v; d_00_i) {
		writeln(fullyQualifiedName!(typeof(dt)), " == ", fullyQualifiedName!(typeof(mixin("test."~v))), " -> ", (fullyQualifiedName!(typeof(dt)) == fullyQualifiedName!(typeof(mixin("test."~v)))));
		static if(fullyQualifiedName!(typeof(dt)) == fullyQualifiedName!(typeof(mixin("test."~v)))) writeln("data_t instance -> ",v);
	};
	return result;
};

public void main(string[] ArgV) {
	writeln(dataIndexes("Hello world.  "));
	writeln(dataIndexes([3, 7, 5]));
	test d_00= test(1, 2, data_t.allocate(40), data_t.allocate(40), 40, data_t.allocate(40));
	writeln(d_00.tupleof[2]);
	writeln(dataIndexes(d_00));
	writeln(" -> ", structDup(d_00));
	writeln(asdf(d_00));
};

require 'ffi'
require 'mylibrary'


#for MallocMessageBuilder
      def new_message
        builder = MallocMessageBuilder.new
        builder.init_root(self)
      end
#for PackedFdMessageBuilder
      def read_from(io)
        reader = PackedFdMessageReader.new(io)
        reader.get_root(self)
      end
#for DynamicList
       DynamicList.class_eval do
    include Enumerable
    def each
      return to_enum(:each) unless block_given?
      (0...size).each do |n|
        yield self[n]
      end
    end
  end


#for DynamicStruct 
       DynamicStruct.class_eval do
    def method_missing(name, *args, &block)
      name = name.to_s

      if name.end_with?("?")
        which == name[0..-2]
      else
        self[name]
      end
    end
  end



 module Schema
    def schema
      @schema
    end

    def load_schema(file_name, imports=[])
      display_name = self.name

      @schema ||= CapnProto::Schema.new

      load_schema_rec = Proc.new do |schema, mod|
        node = schema.get_proto
        nested_nodes = node.nested_nodes

        if node.struct?
          struct_schema = schema.as_struct
          mod.instance_variable_set(:@schema, struct_schema)
          mod.extend(Struct)
        end

        nested_nodes.each do |nested_node|
          const_name = nested_node.name
          const_name[0] = const_name[0].upcase
          nested_mod = mod.const_set(const_name, Module.new)
          nested_schema = schema.get_nested(nested_node.name)
          load_schema_rec.call(nested_schema, nested_mod)
        end
      end

      schema = @schema_parser.parse_disk_file(
        display_name,
        file_name,
        imports);

      load_schema_rec.call(schema, self)
    end

    module Struct
      def schema
        @schema
      end

      def read_from(io)
        reader = StreamFdMessageReader.new(io)
        reader.get_root(self)
      end

      def make_from_bytes(bytes)
        reader = FlatArrayMessageReader.new(bytes)
        reader.get_root(self)
      end

      def new_message
        builder = MallocMessageBuilder.new
        builder.init_root(self)
      end

      def read_packed_from(io)
        raise 'not implemented'
      end
    end
  end
end

MyLibrary.printAddressBook("data.bin");
MyLibrary.writeAddressBook("data.bin");
#direct body of printAddressBook

MyLibrary.getRoot

#MyLibrary.read();


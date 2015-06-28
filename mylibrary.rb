
module MyLibrary
  extend FFI::Library
  ffi_lib "./addressbook.so"

  #.... getRoot ...
  
 # attach_function :DynamicValue,[],
  #attach_function :DynamicStruct,[],:
  #attach_function :DynamicEnum,[],:
  #attach_function :DynamicList,[],:
  #attach_function :List,[], :t
  #attach_function :Schema,[], :
  #attach_function :PackedFdMessageReader,[:string], :void
  attach_function :MallocMessageBuilder, [:string],:void
  attach_function :printAddressBook, [:string],:void
  attach_function :writeAddressBook, [:int],:void
end


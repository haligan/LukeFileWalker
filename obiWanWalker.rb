#!/usr/bin/ruby

########################################################################################################################################
#                                                                                                                                      # 
#                                                        *** LUKE FILEWALKER ***                                                       #
#                                                                                                                                      #
#                                                                                                                                      #
#  This program recursively scans a file system, starting with the directory it is called from, and reports blank and duplicate files  #
#                                                                                                                                      #
########################################################################################################################################

#Needed to generate MD5 value
require 'digest'

#Class for anything that is discovered to be a file
class FileName
 def initialize(filename)
  @fileName = filename 
  setMD5()
 end

 attr_reader :fileName, :md5	

 def setMD5()
  @md5 = Digest::MD5.file @fileName 
 end

 def is_empty?
  if @md5 === "d41d8cd98f00b204e9800998ecf8427e"
   is_empty =true
  else
   is_empty = false
  end
  return is_empty
 end

end

#Lambda needed for number of files scanned, which will be displayed to update user
 def increase_by(i)
  start = 0
  lambda { start += i } 
 end

#Builds an array of FileName Objects (array of files), and prints to console how many files scanned
#iterates through each item in the cwd, determines if it's  a file
#if it's a file push  it to the an array of FileName objects  
#and print every time it scans another 100 items
#or it's a directory, cd into dir and recursively call itself
 def buildArray(localObjCache, increase)
  localDirContents=[] #Array of all items in the cwd
  localDirContents=Dir[Dir.pwd+"/*"] #Builds the array of items in cwd

  localDirContents.each do |item|
   if File.file?(item)
    fileObj = FileName.new(item)
    localObjCache.push(fileObj)
    n = increase.call #printing every 100 files scanned
    if n % 100 == 0
     puts n
    end
   elsif File.directory?(item)
    Dir.chdir(item)
    buildArray(localObjCache, increase) 
   end
  end

  return localObjCache
 end

#Compares each fileObj's md5sum against all
#But first, if it's empty write to push it to a blanks array
#However, if equal create a hash of the files and   
 def findDups(objArray, dupsHashArray, emptyFileArray)
  objArray.each_with_index do |obj, idx1|
   if obj.is_empty?
    emptyFileArray.push(obj.fileName)
    next 
   end
   objArray.each_with_index do |obj2, idx2|
    next if idx1 >= idx2 
     if obj.md5 === obj2.md5
       foundDupHash= {:filePath => obj.fileName, :duplicatePath => obj2.fileName}
      dupsHashArray.push(foundDupHash)
     end
   end
  end 
 end

#Print all blanks to a file
 def printEmpty(emptyFileArray)
  puts "Writing blanks to: /tmp/blanks.txt" 
  File.open("/tmp/blanks.txt", "w") do |f|
   emptyFileArray.each { |element| f.puts(element)}
  end
 end

#Write all dups to a file 
 def printDups(dupsHashArray)
  puts "Writing duplicates to: /tmp/duplicates.txt"
  File.open("/tmp/duplicates.txt","w") do |f|
    dupsHashArray.each { |element| f.puts(element[:filePath] + " : " + element[:duplicatePath]) }
  end 
 end 

#Define main
 def main()
  localObjCache=[]
  emptyFileArray = []
  dupsHashArray = []
  increase = increase_by(1)
  objArray = buildArray(localObjCache, increase)
  findDups(objArray, dupsHashArray, emptyFileArray)
  printEmpty(emptyFileArray)
  printDups(dupsHashArray)
 end

#Let's run this show
main()

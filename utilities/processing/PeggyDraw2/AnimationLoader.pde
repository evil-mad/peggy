
class AnimationLoader
{
  /*
  String[] header;
   String[] RowData;
   String[] footer;
   String[] FileOutput; 
   String[] OneRow; 
   */

  AnimationLoader() {
  }

  AnimationFrames LoadAnimation(String filename) {
    //    println("Loading animation from: " + filename);



    File f = new File(dataPath(""), "PeggyProgram.pde");  
    if (!f.exists()) {
      println("No saved file to load.");

      AnimationFrames animation = new AnimationFrames(cols, rows);
      return animation;
    }
    else
    {

      println("Loading animation from: " + dataPath("PeggyProgram.pde"));

      String PeggyFile[] = loadStrings(dataPath("PeggyProgram.pde"));

      String joinedPeggyFile = join(PeggyFile, ""); 

      //println(joinedPeggyFile);

      String[] list1 = split(joinedPeggyFile, "unsigned int frames = ");  
      String[] list2 = split(list1[1], ";"); 
      int demoAnimationFrameCount = int(list2[0]);
      println("Found " + list2[0] + " frames.");
      String[] list3 = split(list1[1], "prog_uint32_t datastore[] PROGMEM  = {"); 
      String[] list4 = split(list3[1], "}");  
      String[] list5 = splitTokens(list4[0], " , ");
      String[] list6 = split(list4[1], "timestore[] PROGMEM  = {"); 
            
    //  println(list6[1]);   // List data found (durations)
      String[] list7 = splitTokens(list6[1], ", ");
       
       
       int durTemp = int(list7[0]);
       SteadyRate = true;
       durationTypeButton.updateLabel("All frames: ");
       
      // Create a new animation
      AnimationFrames animation = new AnimationFrames(cols, rows);

      int i = 0;

      // Repeat while there are still frames to load
      while(i < demoAnimationFrameCount) {

        // For demonstration: buld a  frame
        int[] frameData = new int[rows*cols];
        
        for (int rownum = 0; rownum < rows; rownum++) { 
          for (int colnum = 0; colnum < 25; colnum++) {
            if ((  int(list5[rownum + 25*i]) & (1 << colnum)) > 0)
              frameData[rownum*25 + colnum] = 1;
            else
              frameData[rownum*25 + colnum] = 0;
          }
        } 
      
        int duration = int(list7[i]);
        
        if (durTemp != duration){
           SteadyRate = false;
           durationTypeButton.updateLabel("This frame: "); 
        }

        // Add the frame to the end of our animation
        animation.addFrame(new AnimationFrame(cols, rows, frameData, duration), animation.getFrameCount());

        // For demonstration: advance to next frame
        i++;
      }

      
     
      return animation;
    }
  }

  void SaveAnimation(String filename, AnimationFrames animation) {
    // Note: filename is currently ignored.  The file will be saved to the 
    // same directory where this sketch is located, and stored within the data folder

    File outputDir = new File(dataPath("") , "PeggyProgram");  

    println("Saving animation to: " + dataPath("PeggyProgram.pde"));


    String[] header;
    String[] footer;
    int rowdata; 
    String[] contentString =  new String[1];
    String[] contentString2 =  new String[1];
    String[] FileOutput;
    int rowcount;
    int framecount ;

  if (UsePeggy2SerialLibrary)
    header = loadStrings("PeggySerialHeader.txt");
    else
    header = loadStrings("PeggyHeader.txt");
    
    footer = loadStrings("PeggyFooter.txt");

    FileOutput = header;

    framecount = animation.getFrameCount();


    FileOutput = append(FileOutput,"unsigned int frames = " + framecount + ";\n");

    FileOutput = append(FileOutput,"prog_uint32_t datastore[] PROGMEM  = {");


    contentString[0] = "";

    rowcount = 0;

    // For each frame
    for (int i = 0; i < framecount; i++) {

      println("Frame: " + i);

      println("Duration: " +  animation.getFrame(i).getDuration());
      // Load the frame data
      int data[] = animation.getFrame(i).getFrameData();

      for (int rownum = 0; rownum < rows; rownum++) {
        rowdata = 0;
        for (int colnum = 0; colnum < 25; colnum++) {

          if (data[rownum*25 + colnum] > 0)
          {
            rowdata += (1 << colnum);
          }
        }


        contentString = append(contentString,str(rowdata));

        if ( (rownum == (rows - 1)) && ( i == (framecount - 1)   ))
        {
        }
        else
        {
          contentString = append(contentString,",");
          rowcount =  rowcount + 1;
          if ( rowcount == 10) {
            contentString = append(contentString,"\n"); 
            rowcount = 0;
          }
        }
      }

      // Print the frame data
      for (int j = 0; j < data.length; j++) {
        print(data[j] > 0 ?"[0]":" . ");
        if ((j + 1) % cols == 0) {
          print("\n");
        }
      }

      print("\n");
    } // End per frame section
    FileOutput = append(FileOutput, join( contentString, " ")); 
    FileOutput = append(FileOutput, "};\nprog_uint16_t timestore[] PROGMEM  = {");


    contentString2[0] = "";
    rowcount = 0;
    for (int i = 0; i < framecount; i++) {
      contentString2 = append(contentString2,str(animation.getFrame(i).getDuration()));
      if (i != (framecount - 1)) {
        contentString2 = append(contentString2,", ");
      }
      rowcount =  rowcount + 1;
      if ( rowcount == 10) {
        contentString2 = append(contentString2,"\n"); 
        rowcount = 0;
      }
    }
    contentString2 = append(contentString2,"\n};\n\n"); 

    FileOutput = append(FileOutput, join( contentString2, "")); 



    FileOutput = concat(FileOutput, footer);
    saveStrings(dataPath("PeggyProgram.pde"), FileOutput);
  }
}


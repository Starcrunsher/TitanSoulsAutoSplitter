state("TITAN")
{
    int frames : "TITAN.exe", 0x003165EC, 0x30;
    int deathCounter : "TITAN.exe", 0x003165EC, 0x34;
    int killCounter : "TITAN.exe", 0x003165EC, 0x38;
}

startup
{
    settings.Add("splitV2", false, "Split after exiting the boss area?");

    for(int i = 1; i <= 19; i++)
    {
        settings.Add("splitV2_splitTitan" + i, true, "Split at titan " + i + "?", "splitV2");
        settings.Add("splitV2_splitTitan" + i + "_atKill",  false, "Split titan " + i + " at Kill?", "splitV2_splitTitan" + i);
    }

    settings.Add("splitSaves", false, "Split on every save");
    settings.Add("splitSaves_WaitOnKillSplit", false, "Wait on splits that end with \"Kill\"", "splitSaves");
}

init
{
    Action resetVars = () =>
    {
        vars.killCounter = 0;
        vars.titanKillFrame = 0;
        vars.titanKilled = false;
        vars.shouldSplit = false;
        vars.startRun = false;
        vars.ingameTime = 0;
    };
    vars.resetVars = resetVars;
    vars.resetVars();
    
    Func<bool> isLastSplit = () =>
    {
        return timer.CurrentSplitIndex == (timer.Run.Count - 1);
    };
    vars.isLastSplit = isLastSplit;

    Func<string> getCurrentSplitName = () => {
        try 
        {
            return timer.CurrentSplit.Name;
        }
        catch (Exception ex)
        {
            return "";
        }
    };
    vars.getCurrentSplitName = getCurrentSplitName;
    
    Func<bool> shouldSplitAtTitan = () =>
    {
        if(vars.killCounter > 19)
        {
            return true;
        }
        return settings["splitV2_splitTitan" + (vars.killCounter)];
    };
    vars.shouldSplitAtTitan = shouldSplitAtTitan;
    
    Func<bool> shouldSplitAtTitanKill = () =>
    {
        if(vars.killCounter > 19)
        {
            return true;
        }
        return settings["splitV2_splitTitan" + (vars.killCounter) + "_atKill"];
    };
    vars.shouldSplitAtTitanKill = shouldSplitAtTitanKill;
    
    vars.save0File = modules.First().FileName.Replace("TITAN.exe", "") + @"data\SAVE\0.txt";
    vars.lastSaveWrite = File.GetLastWriteTime(vars.save0File);
    Func<bool> checkNewWriteToSave = () =>
    {
        DateTime lastSaveWrite = File.GetLastWriteTime(vars.save0File);
        if(!vars.lastSaveWrite.Equals(lastSaveWrite))
        {
            vars.lastSaveWrite = lastSaveWrite;
            return true;
        }
        return false;
    };
    vars.checkNewWriteToSave = checkNewWriteToSave;
}

update
{
    //start condition
    if(old.frames == 0 && old.frames < current.frames && current.frames < 60)
    {
        vars.resetVars();
        vars.startRun = true;
    }
    
    //ingameTime calculation
    if(current.frames > old.frames && (current.frames - old.frames) < 60)
    {
        vars.ingameTime += (current.frames - old.frames);
    }
    
    if(settings["splitV2"])
    {
        
        bool saveWriteHappened = vars.checkNewWriteToSave();
        
        //check if titan was killed
        if(vars.killCounter + 1 == current.killCounter)
        {
            vars.killCounter = current.killCounter;
            if(vars.shouldSplitAtTitan() || vars.isLastSplit())
            {
                vars.titanKilled = true;
                vars.titanKillFrame = current.frames;
            }
        }
        
        if(vars.titanKilled)
        {
            if(vars.shouldSplitAtTitanKill()
                || (saveWriteHappened && (vars.titanKillFrame + 15) < current.frames)
                || (old.frames == 0 && current.frames > 600)
                || (current.deathCounter == old.deathCounter + 1)
            )
            {
                vars.titanKilled = false;
                vars.shouldSplit = true;
            }
        }
    }
    else if(settings["splitSaves"])
    {
        bool saveWriteHappened = vars.checkNewWriteToSave();
        if(saveWriteHappened)
        {
            bool killHappened = current.killCounter > vars.killCounter;
            vars.killCounter = current.killCounter;

            if(settings["splitSaves_WaitOnKillSplit"])
            {
                if(vars.getCurrentSplitName().EndsWith("Kill"))
                {
                    if(killHappened)
                    {
                        vars.shouldSplit = true;
                    }
                }
                else
                {
                    vars.shouldSplit = true;
                }
            }
            else
            {
                vars.shouldSplit = true;
            }
        }
    }
    else
    {
        //old split behavior moved to update
        //should always split for risky skips at least after re-entering the game
        if(vars.killCounter + 1 == current.killCounter)
        {
          vars.killCounter = current.killCounter;
          vars.shouldSplit = true;
        }
    }

}

start
{
  if(vars.startRun)
  {
      vars.startRun = false;
      return true;
  }
  return false;
}

split
{
  if(vars.shouldSplit)
  {
      vars.shouldSplit = false;
      return true;
  }
  return false;
}

isLoading
{
    return true;
}

gameTime
{
    return TimeSpan.FromSeconds(vars.ingameTime / 60.0f);
}

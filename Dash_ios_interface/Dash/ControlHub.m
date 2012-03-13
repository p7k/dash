//
//  ControlHub.m
//  Dash
//
//  Created by Daniel Iglesia on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ControlHub.h"

@implementation ControlHub
@synthesize allGroupNamesArray, classInfoArray, allTopLevelViewControllersArray, callQueue, callListViewController, classInfoInGroupArray, currentGroupString;

NSString* _archiveLocation; //archive is now a DICT containing a classInfoArray and group array
+ (NSString*)archiveLocation{
	if (_archiveLocation == nil)
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		_archiveLocation = [[documentsDirectory stringByAppendingPathComponent:@"PresetsDict.ar"] retain];       
		//printf("\ntemp= %s ", [_archiveLocation cString]);
	}
	return _archiveLocation;
}

-(id) init{
    //allGroupNamesArray = [[NSMutableArray alloc]init ];
    
    callQueue = [[NSMutableArray alloc]init ];
    allTopLevelViewControllersArray = [[NSMutableArray alloc]init];
    
    //first, read classInfoArray from local copy before internet sync
    
    myDataDict = [self loadLocalInfoDict];//complex: autoreleased from storage, but not from create new!
   
    classInfoArray = [myDataDict objectForKey:@"classInfoArray"];
    [classInfoArray retain];
    allGroupNamesArray = [myDataDict objectForKey:@"allGroupNamesArray"];
    //[allGroupNamesArray insertObject:@"Full Roster" atIndex:0];
    [allGroupNamesArray retain];
    
    classInfoInGroupArray = [[NSMutableArray alloc]init ];
    for(StudentInfo* studentInfo in  classInfoArray){
        [classInfoInGroupArray addObject:studentInfo];
    }
    
    
    //test
    //for(StudentInfo* si in classInfoArray) printf("\n%s", [[si fullName]cString]);
          
    return self;
}

-(void) reloadClassInfoInGroups{
    [classInfoInGroupArray removeAllObjects];
   // printf("\nreload class info in groups:");
    for(StudentInfo* studentInfo in classInfoArray){
        for (NSString* groupString in [studentInfo groupStringArray]){
            if([groupString compare:currentGroupString]==NSOrderedSame){
                [ classInfoInGroupArray addObject:studentInfo];
                //printf("%s", [[studentInfo fullName] cString]);
                break;//stop looking at this student, move to next
            }
        }
    }
}

//pull from server
-(void)sync{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
    
    // request data from the api
    NSError * error = nil;
    NSURL * url = [NSURL URLWithString:@"http://23.21.212.190:5000/api/v1/student"];
    NSString *studentJson = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];    
   
    NSURL * groupsUrl = [NSURL URLWithString:@"http://23.21.212.190:5000/api/v1/group"];
    NSString *groupsJson = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];    
    
    printf("\n========CLASSROOM\n%s", [studentJson cString]);
    
    if (studentJson!=nil && [studentJson length]>0) {//check for sucess
        [classInfoArray release];//release local version
        classInfoArray = [[StudentInfo createStudentListWithJsonString:studentJson] mutableCopy];
        
        [allGroupNamesArray release];
        allGroupNamesArray = [groupsJson objectFromJSONString];//shold be array of strings
        
        printf("\ninternet success, class info array with %d records", [classInfoArray count]);
        
        //on successful pull, save to local
        [self saveLocaLInfoDict];
        for(UIViewController* vc in allTopLevelViewControllersArray){
            [vc performSelectorOnMainThread:@selector(syncFinishedWithSuccess:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:NO];
        }
        
        
        
    }
    else  {
        
        for(UIViewController* vc in allTopLevelViewControllersArray){
            printf("*");
            [vc performSelectorOnMainThread:@selector(syncFinishedWithSuccess:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:NO];
        }
    }
    
    [pool release];
}

//temp hack
/*-(NSMutableDictionary*) loadLocalInfoDict{
    NSMutableArray* tempArray;
	if ([[NSFileManager defaultManager] fileExistsAtPath:[ControlHub archiveLocation]]) {
		tempArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[ControlHub archiveLocation]];
		printf("\nlocal array file exists, has %d records ", [tempArray count]);
		//printf("\ninit dictionary:%s", [[trackInfoDict description]cString]);
	}
    else{ 
        tempArray=[[NSMutableArray alloc]init ];
    }
    //[tempArray retain];
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init ];
    [tempDict setObject:tempArray forKey:@"classInfoArray"];
    return [tempDict autorelease];
}*/

-(NSMutableDictionary*) loadLocalInfoDict{//TODO: check that local file is of right type?
    NSMutableDictionary* tempDict;
	if ([[NSFileManager defaultManager] fileExistsAtPath:[ControlHub archiveLocation]]) {
		tempDict = [NSKeyedUnarchiver unarchiveObjectWithFile:[ControlHub archiveLocation]];
		printf("\nlocal data file exists, has %d student records, %d group names ", [[tempDict objectForKey:@"classInfoArray"] count],  [[tempDict objectForKey:@"allGroupNamesArray"] count]);
		//printf("\ninit dictionary:%s", [[trackInfoDict description]cString]);
	}
    else{ 
        tempDict=[[NSMutableDictionary alloc]init ];
    }
    //[tempArray retain];//retain  on unpacking
    return tempDict;// autorelease];
}

-(void) saveLocalInfoDict{
	printf("\ncalled save");
	//printf("contents:");
	/*for(int i=0;i<[classInfoArray count];i++){
     printf("\n-%s -- %d", [[[stateInfoArray objectAtIndex:i] presetName] cString], [[stateInfoArray objectAtIndex:i] osc1Cent] );
     }*/
    //should be released/null
    printf("\nsaving..ismyDataDict nil? should be: %d", myDataDict==nil);
    myDataDict = [[NSMutableDictionary alloc]init ];
    [myDataDict setObject:classInfoArray forKey:@"classInfoArray"];
    [myDataDict setObject:allGroupNamesArray forKey:@"allGroupNamesArray"];
    
	BOOL result = [NSKeyedArchiver archiveRootObject:myDataDict toFile:[ControlHub archiveLocation]];	
	if(result)printf(" --save successful");
	else printf("\nsave UNsuccessful!");
    [myDataDict release];
}

-(void)reloadAllMainTableViews{
    for(UIViewController* vc in allTopLevelViewControllersArray){
        [[vc mainTableView] reload];
    }
}

@end

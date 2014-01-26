#include "existing_function.h"

void addGlobalFunctionHtable(struct hashtable * h, char * name_arg, char * params){
  
  struct Variable *function=NULL;
  function=malloc(sizeof(struct Variable));
  char * name=malloc(FUNCTION_NAME_SIZE);
  char * llvm_name=malloc(FUNCTION_NAME_SIZE);
  strcpy(name,name_arg);
  strcpy(llvm_name,"@");
  strcat(llvm_name,name_arg);
  strcat(llvm_name,"(");
  strcat(llvm_name,params);
  strcat(llvm_name,")");
  function->name=name;
  function->llvm_name;
  htable_insert(h,name,function);
}



char * global_functions(){
  char* code=malloc(1024);
  strcpy(code,"declare float @norm_pi_pi(float %a)\n");
  strcat(code,"declare float @get_track_angle(%struct.tTrkLocPos*)\n");

  strcat(code,"declare float @get_pos_to_right(%struct.tTrkLocPos*)\n");
  strcat(code,"declare float @get_pos_to_middle(%struct.tTrkLocPos*)\n");
  strcat(code,"declare float @get_pos_to_left(%struct.tTrkLocPos*)\n");
  strcat(code,"declare float @get_pos_to_start(%struct.tTrkLocPos*)\n");
  strcat(code,"declare float @get_track_seg_length(%struct.trackSeg*)\n");
  strcat(code,"declare float @get_track_seg_width(%struct.trackSeg*)\n");
  strcat(code,"declare float @get_track_seg_start_width(%struct.trackSeg*)\n");
  strcat(code,"declare float @get_track_seg_end_width(%struct.trackSeg*)\n");
  strcat(code,"declare float @get_track_seg_radius(%struct.trackSeg*)\n");
  strcat(code,"declare float @get_track_seg_right_radius(%struct.trackSeg*)\n");
  strcat(code,"declare float @get_track_seg_left_radius(%struct.trackSeg*)\n");
  strcat(code,"declare float @get_track_seg_arc(%struct.trackSeg*)\n");
  strcat(code,"declare %struct.trackSeg* @get_track_seg_next(%struct.trackSeg*)\n");
  strcat(code,"declare float @get_car_yaw(%struct.CarElt*)\n");

  return code;
}

char * printDriveTop(struct hashtable*h) {

  //printf("define void @drive(i32 %%index, %%struct.CarElt* %%car, %%struct.Situation* %%s) {\n");
  char * code=malloc(2048);
  strcpy(code,"%ctrl		= getelementptr %struct.CarElt* %car, i32 0, i32 5\n");
  strcat(code,"%public_car	= getelementptr %struct.CarElt* %car, i32 0, i32 2\n");
  strcat(code,"%pos		= getelementptr %struct.tPublicCar* %public_car, i32 0, i32 3\n");
  strcat(code,"%seg.addr	= getelementptr %struct.tTrkLocPos* %pos, i32 0, i32 0\n");
  strcat(code,"%seg		= load %struct.trackSeg** %seg.addr\n\n");

  strcat(code,"%steerCmd		= getelementptr %struct.tCarCtrl* %ctrl, i32 0, i32 0\n");
  strcat(code,"%accelCmd	= getelementptr %struct.tCarCtrl* %ctrl, i32 0, i32 1\n");
  strcat(code,"%brakeCmd	= getelementptr %struct.tCarCtrl* %ctrl, i32 0, i32 2\n");
  strcat(code,"%clutchCmd	= getelementptr %struct.tCarCtrl* %ctrl, i32 0, i32 3\n");
  strcat(code,"%gearCmd		= getelementptr %struct.tCarCtrl* %ctrl, i32 0, i32 4\n\n");
  
  // add 
  struct Variable * ctrl=malloc(sizeof(struct Variable));
 
  // add position local variable to the htable
  struct Variable * pos=malloc(sizeof(struct Variable));
  pos->cmpt=VAR;
  pos->type=STRUCTURE;
  pos->name="pos";
  pos->llvm_name=malloc(20);
  strcpy(pos->llvm_name,"%pos");
  strcpy(pos->code,"%struct.tTrkLocPos* %pos");
  htable_insert(h,"pos",(void*)pos);

  // add car local variable (parameter) to the htable
  struct Variable * car=malloc(sizeof(struct Variable));
  car->cmpt=VAR;
  car->type=STRUCTURE;
  car->name="car";
  car->llvm_name=malloc(20);
  strcpy(car->llvm_name,"%car");
  strcpy(car->code," %struct.CarElt* %car");
  htable_insert(h,"car",(void*)car);
  
  
  /* struct Variable * seg=malloc(sizeof(struct Variable)); */
  /* struct Variable * steer=malloc(sizeof(struct Variable)); */
  /* struct Variable * accelCmd=malloc(sizeof(struct Variable)); */
  /* struct Variable * brakeCmd=malloc(sizeof(struct Variable)); */
  /* struct Variable * clutchCmd=malloc(sizeof(struct Variable)); */
  /* struct Variable * gear=malloc(sizeof(struct Variable)); */
  /* //struct Variable * seg_addrl=malloc(sizeof(struct Variable)); */

  /* htable_insert(h,,ctrl); */
  /* //htable_insert(h,,seg_addr); */
  /* htable_insert(h,,ctrl);   */
  /* htable_insert(h,,ctrl); */
  /* htable_insert(h,,ctrl); */
  /* htable_insert(h,,ctrl); */
  /* htable_insert(h,,ctrl); */
  /* htable_insert(h,,ctrl); */
  /* htable_insert(h,,ctrl); */
  /* htable_insert(h,,ctrl); */

  return code;
}















class RecordController < ApplicationController

  # posts task item from iPhone to DB
  def taskInfo
    puts "getting task info..."
    @task = Task.new
    
    @task.version_number = params[:version_number]
    @task.session_id = params[:session_id]
    @task.user_id = params[:user_id]
    @task.experimenter_id = params[:experimenter_id]
    @task.device_type = params[:device_type]

    @task.song_id = params[:song_id]
    @task.task_order = params[:task_order]
    
    @task.tap_data = params[:tap_data]
    @task.tap_off_data = params[:tap_off_data]
    @task.tap_y_data = params[:tap_y_data]
    @task.tap_x_data = params[:tap_x_data]
    
    @task.with_music = params[:with_music]
    @task.song_familiarity = params[:song_familiarity]
    @task.audio_helpful = params[:audio_helpful]

    if @task.save then
      render :text => "success!"
     else
      render :text => "failed..."
     end
  end

  # posts user item from iPhone to DB
  def userInfo
    @user = User.new
    @user.user_id = params[:user_id]
    @user.age = params[:age]
    @user.gender = params[:gender]
    @user.listening_habits = params[:listening_habits]
    @user.instrument_training = params[:instrument_training]
    @user.theory_training = params[:theory_training]
    @user.handedness = params[:handedness]
    @user.tone_deaf = params[:tone_deaf]
    @user.arrythmic = params[:arrythmic]
    @user.native_language = params[:native_language]

    if @user.save then
      render :text => "success!"
     else
      render :text => "failed..."
     end
  end

  # posts song item from iPhone to DB
  def songInfo
    @song = Song.new
    @song.title = params[:title]
    @song.artist = params[:artist]
    @song.year = params[:year]
    @song.ground_truth = params[:ground_truth]

    if @song.save then
      render :text => "success!"
     else
      render :text => "failed..."
     end
  end
end

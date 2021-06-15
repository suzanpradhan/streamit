import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/BaseResponse.dart';
import 'package:streamit_flutter/models/CommentModel.dart';
import 'package:streamit_flutter/models/DashboardResponse.dart';
import 'package:streamit_flutter/models/LoginResponse.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/models/MovieDetailResponse.dart';
import 'package:streamit_flutter/models/ViewAllResponse.dart';
import 'package:streamit_flutter/models/WatchListResponse.dart';
import 'package:streamit_flutter/screens/home_screen.dart';
import 'package:streamit_flutter/utils/common.dart';
import 'package:streamit_flutter/utils/constants.dart';

import 'network_utils.dart';

Future<LoginResponse> token(Map request) async {
  LoginResponse res = LoginResponse.fromJson(await (handleResponse(await postRequest('jwt-auth/v1/token', request, aAuthRequired: false))));

  await setValue(TOKEN, res.token);
  getDetails(logRes: res);

  await setValue(isLoggedIn, true);
  mIsLoggedIn = true;

  appStore.setFirstName(res.first_name.validate());
  appStore.setLastName(res.last_name.validate());
  appStore.setUserProfile(res.profile_image.validate());

  return res;
}

Future<void> logout(BuildContext context) async {
  //await clearSharedPref();
  mUserId = 0;
  await removeKey(TOKEN);
  await removeKey(USER_ID);
  await removeKey(NAME);
  await removeKey(LAST_NAME);
  await removeKey(USER_PROFILE);
  await removeKey(USER_EMAIL);
  await removeKey(USERNAME);
  await removeKey(SUBSCRIPTION_PLAN_STATUS);
  await removeKey(SUBSCRIPTION_PLAN_ID);
  await removeKey(SUBSCRIPTION_PLAN_START_DATE);
  await removeKey(SUBSCRIPTION_PLAN_EXP_DATE);
  await removeKey(SUBSCRIPTION_PLAN_STATUS);
  await removeKey(SUBSCRIPTION_PLAN_TRIAL_STATUS);
  await removeKey(SUBSCRIPTION_PLAN_NAME);
  await removeKey(SUBSCRIPTION_PLAN_AMOUNT);
  await removeKey(SUBSCRIPTION_PLAN_TRIAL_END_DATE);

  await setValue(isFirstTime, false);
  await setValue(isLoggedIn, false);
  mIsLoggedIn = false;

  HomeScreen().launch(context, isNewTask: true);
}

Future<BaseResponse> forgotPassword(Map request) async {
  return BaseResponse.fromJson(await (handleResponse(await postRequest('streamit-api/api/v1/streamit/forgot-password', request, aAuthRequired: false))));
}

Future register(Map request) async {
  return await handleResponse(await postRequest('streamit-api/api/v1/auth/registration', request, aAuthRequired: false));
}

Future<BaseResponse> validateToken() async {
  return BaseResponse.fromJson(await (handleResponse(await postRequest('jwt-auth/v1/token/validate', {}))));
}

Future<BaseResponse> changePassword(Map request) async {
  return BaseResponse.fromJson(await (handleResponse(await postRequest('streamit-api/api/v1/streamit/change-password', request))));
}

Future<DashboardResponse> getDashboardData(Map request, {String type = dashboardTypeHome}) async {
  return DashboardResponse.fromJson(await (handleResponse(await postRequest('streamit-api/api/v1/streamit/get-dashboard?type=$type&user_id=$mUserId', request))));
}

Future<MovieResponse> getWatchList() async {
  return MovieResponse.fromJson(await (handleResponse(await getRequest('streamit-api/api/v1/streamit/get-watchlist'))));
}

Future<MovieResponse> searchMovie(String aSearchText, {int page = 1}) async {
  return MovieResponse.fromJson(await (handleResponse(await getRequest('streamit-api/api/v1/streamit/search-list?search=$aSearchText&user_id=$mUserId&paged=$page&posts_per_page=$postPerPage'))));
}

Future<ViewAllResponse> viewAll(int index, String type, {int page = 1}) async {
  return ViewAllResponse.fromJson(await (handleResponse(await getRequest('streamit-api/api/v1/streamit/slider-view-all?user_id=$mUserId&paged=$page&posts_per_page=$postPerPage&slider_id=$index&type=$type'))));
}

Future<MovieDetailResponse> movieDetail(int aId) async {
  return MovieDetailResponse.fromJson(await (handleResponse(await getRequest('streamit-api/api/v1/movie/get-detail?movie_id=$aId&user_id=$mUserId'))));
}

Future<MovieDetailResponse> tvShowDetail(int aId) async {
  return MovieDetailResponse.fromJson(await (handleResponse(await getRequest('streamit-api/api/v1/tv_show/get_tv_show_detail?tv_show_id=$aId&user_id=$mUserId'))));
}

Future<MovieDetailResponse> episodeDetail(int? aId) async {
  return MovieDetailResponse.fromJson(await (handleResponse(await getRequest('streamit-api/api/v1/tv_show_episode/get_episode_detail?episode_id=$aId&user_id=$mUserId'))));
}

Future<LikeAndWatchListResponse> likeMovie(Map request) async {
  return LikeAndWatchListResponse.fromJson(await (handleResponse(await postRequest('streamit-api/api/v1/streamit/like-movie-show', request))));
}

Future<LikeAndWatchListResponse> watchlistMovie(Map request) async {
  return LikeAndWatchListResponse.fromJson(await (handleResponse(await postRequest('streamit-api/api/v1/streamit/add-remove-watchlist', request))));
}

Future<LoginResponse> getUserProfileDetails() async {
  return LoginResponse.fromJson(await (handleResponse(await getRequest('streamit-api/api/v1/streamit/view-profile'))));
}

Future<MovieResponse> getVideos() async {
  return MovieResponse.fromJson(await (handleResponse(await getRequest('streamit-api/api/v1/video/get_list'))));
}

Future<MovieDetailResponse> getVideosDetail(int id) async {
  return MovieDetailResponse.fromJson(await (handleResponse(await getRequest('streamit-api/api/v1/video/get-detail?video_id=$id'))));
}

Future<List<CommentModel>> getComments({int? postId, int? page, int? commentPerPage}) async {
  Iterable it = await (handleResponse(await getRequest('wp/v2/comments?post=$postId&page=$page&per_page=$commentPerPage&order=asc')));
  return it.map((e) => CommentModel.fromJson(e)).toList();
}

Future<CommentModel> addComment(Map request) async {
  return CommentModel.fromJson(await (handleResponse(await postRequest('wp/v2/comments', request))));
}

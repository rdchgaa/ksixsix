import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Languages {
  static LocalizationsDelegate<Languages> delegate;

  static LocalizationsDelegate<Languages> getDelegate(BuildContext context) {
    return delegate = _AppLocalizationsDelegate(context);
  }

  final String loginButtonLabel;

  final String contactText;

  final String myGroupText;

  final String changeLanguage;

  final String selectLanguages;

  final String okButtonLabel;

  final String cancelButtonLabel;

  final String messageText;

  final String contactsText;

  final String seeMoreText;

  final String groupText;

  final String chatRecordText;

  final String deleteConversationText;

  final String deleteConversation;

  final String clearHistory;

  final String clearHistoryText;

  final String pageSearchMessage;

  final String pageSearchFriend;

  final String pageSearchGroup;

  final String searchText;

  final String friend;

  final String newGroupText;

  final String newEncryptedConversation;

  final String newContactText;

  final String newSecretContactText;

  final String newGroupContactText;

  final String addMemberText;

  final String onlineStatusText;

  final String phoneText;

  final String clearChatRecordsText;

  final String viewChatRecordsText;

  final String toppingText;

  final String noticeText;

  final String sendMessageText;

  final String addContactText;

  final String editContactText;

  final String removeContactText;

  final String stopContactText;

  final String loginText;

  final String loginPagePhoneText;

  final String loginPageCodeText;

  final String loginPagePhoneInput;

  final String loginPageCodeNum;

  final String nextButton;

  final String pageChatDate;

  final String pageChatTime;

  final String remarksText;

  final String newFriendText;

  final String sendText;

  final String inputMsgHintText;

  final String recordingStartButtonText;

  final String recordingEndButtonText;

  final String cancelRecording;

  final String feedbackText;

  final String shareAppText;

  final String versionUpdateText;

  final String aboutUsText;

  final String languageText;

  final String dataStorageText;

  final String privacyAndSecurityText;

  final String notificationAndSoundText;

  final String favoriteText;

  final String personalDataText;

  final String headPortraitText;

  final String idText;

  final String nicknameText;

  final String genderText;

  final String privateChatText;

  final String clickText;

  final String dialogueInformText;

  final String otherText;

  final String applicationNotificationText;

  final String receivingPromptToneText;

  final String vibrationText;

  final String voicePromptText;

  final String backstageServiceText;

  final String backstageServiceTipText;

  final String backgroundNetworkConnectionText;

  final String backgroundNetworkConnectionTipText;

  final String briefIntroductionText;

  final String finallyOnLineIdleText;

  final String invitationPermissionControlText;

  final String holderText;

  final String personalInformationText;

  final String blacklistText;

  final String shieldUserText;

  final String equipmentText;

  final String loginEquipmentText;

  final String accountText;

  final String accountRetentionPeriodText;

  final String dataUsageText;

  final String storageUsageText;

  final String onOneIsAllowedText;

  final String fileStorageTimeText;

  final String clearCacheText;

  final String clearingLocalDataText;

  final String wifiText;

  final String wifiTipText;

  final String mobileDataText;

  final String automaticallyDownload;

  final String addFriendText;

  final String inputGroupNameHint;

  final String selectGroupAvatarToast;

  final String inputGroupNameToast;

  final String groupInfoNumberText;

  final String screenshotsManagementText;

  final String banScreenshotsText;

  final String screenShotTipText;

  final String circleText;

  final String saveText;

  final String maleText;

  final String female;

  final String addText;

  final String circleTipText;

  final String circleAddText;

  final String circleEnterText;

  final String addMemberToast;

  final String memberIdentityFounder;

  final String memberIdentityMember;

  final String exitText;

  final String maskedUsersText;

  final String pictureText;

  final String videoText;

  final String videoTextCall;

  final String audioTextCall;

  final String fileText;

  final String pictureMobileTipText;

  final String videoMobileTipText;

  final String fileMobileTipText;

  final String unknownText;

  final String maskedUsersTipText;

  final String presentDeviceText;

  final String othersDeviceText;

  final String scanQRCodeText;

  final String deviceQuitTipText;

  final String deviceOtherQuitTipText;

  final String onlineText;

  final String updateSuccessText;

  final String everyoneText;

  final String myContactText;

  final String hideText;

  final String lastLoginTimeText;

  final String retainMonthText;

  final String fileStorageTimeMonthText;

  final String fileStorageThreeDaysText;

  final String fileStorageWeekendText;

  final String fileStorageForeverText;

  final String userAgreementText;

  final String PrivacyAgreement;

  final String loginPhoneTipText;

  final String loginCodeTipText;

  final String getCodeTipText;

  final String countdownText;

  final String codeErrorTipText;

  final String cancelShieldText;

  final String shieldUserLengthText;

  final String mediaTypeText;

  final String allSilenceText;

  final String photographersText;

  final String forbidSendTxtText;

  final String forbidSendIconText;

  final String forbidSendFileText;

  final String forbidSendVoiceText;

  final String notOnlineText;

  final String modifyPhotoText;

  final String addSuccessText;

  final String personalizedSignatureText;

  final String clearedHistoryListText;

  final String newFriendsText;

  final String agreementText;

  final String refuseText;

  final String hasAgreedText;

  final String hasRefuseText;

  final String addSuccessFriendText;

  final String addAgreeFriendText;

  final String addRefuseFriendText;

  final String searchContactsText;

  final String editText;

  final String setGroupPictureText;

  final String groupIntroduceText;

  final String editGroupPhotoText;

  final String inputGroupNameText;

  final String selGroupPicture;

  final String informationText;

  final String searchInputText;

  final String managementGroupText;

  final String searchOnlineRecordText;

  final String clearOnlineRecordText;

  final String inviteLinkText;

  final String inviteMemberText;

  final String groupMemberText;

  final String editGroupInfoText;

  final String delExitGroupText;

  final String setManganeseText;

  final String setMemberText;

  final String groupInRemove;

  final String tipText;

  final String cancelText;

  final String clearButtonLabel;

  final String groupManagementText;

  final String joinSetText;

  final String memberLookMsgTip;

  final String newMemberJoinNotTip;

  final String memberInteractText;

  final String memberAndInvisible;

  final String forbidInGroupAddTip;

  final String onlyManageAddMember;

  final String msgLimitsText;

  final String allowSendText;

  final String allowSendPictureText;

  final String allowSendVoiceText;

  final String allowSendFileText;

  final String bannedSetText;

  final String allBannedText;

  final String startTimeText;

  final String endTimeText;

  final String dissolveGroupText;

  final String dissolveButtonLabel;

  final String adverseDelSuccessTip;

  final String versionTips;

  final String phoneSelPicture;

  final String loadingText;

  final String noMoreResultText;

  final String exitGroupTip;

  final String cancelMemberTip;

  final String clearMsgRecordIp;

  final String dissolveGroupTip;

  final String feedbackTitleTip;

  final String feedbackContentTip;

  final String feedbackTitleText;

  final String feedbackContentText;

  final String nicknameTipText;

  final String inpNicknameCorrectTipText;

  final String mobileDataTipText;

  final String cacheClearTipText;

  final String cacheTipText;

  final String submitButtonLabel;

  final String notFilledText;

  final String pageSearchHint;

  final String enterCodeText;

  final String briefIntroductionTipText;

  final String shieldSuccessText;

  final String cancelSuccessText;

  final String delConfirmTipText;

  final String shieldConfirmTipText;

  final String searchCountText;

  final String shareLinkTip;

  final String editGroupInfoTip;

  final String addGroupMemberTip;

  final String removeGroupMemberTip;

  final String microphonePermissionTipText;

  final String msgClearTipText;

  final String nowExperienceTipText;

  final String reloadLoginTipText;

  final String logAgainText;

  final String myCreateGroupText;

  final String myManageGroupText;

  final String myJoinGroupText;

  final String groupMemberCountText;

  final String groupIntroductionHint;

  final String exitGroupMemberTip;

  final String noCircleTipText;

  final String joinCircleTipText;

  final String myCircleText;

  final String circleJoinNumberText;

  final String backText;

  final String circleSwitchTipText;

  final String voiceUnderTime;

  final String clearRecordsText;

  final String msgNotDisturbText;

  final String msgTurnOnText;

  final String pinnedConversationText;

  final String operateTipText;

  final String cancelPinnedConversationText;

  final String addCircleTipText;

  final String groupPhotoText;

  final String groupNameText;

  final String groupIntroText;

  final String addNewCircleText;

  final String privateManagementText;

  final String privateManagementTipText;

  final String twoWayRevokeText;

  final String twoWayRevokeTipText;

  final String moreSecureText;

  final String moreSecureTipText;

  final String clearChatRecordsTipText;

  final String inviteText;

  final String enterGroupText;

  final String chatRecordsCountText;

  final String voiceText;

  final String groupTypeText;

  final String groupLinkText;

  final String bannedMemberText;

  final String publicText;

  final String privateText;

  final String bannedMemberLengthText;

  final String bannedMemberTipText;

  final String removeText;

  final String updateManageLimitsText;

  final String updateGroupInfoText;

  final String delGroupInfoText;

  final String memberInteractSetText;

  final String memberLimitsSetText;

  final String bannedToPostSetText;

  final String bannedUserSetText;

  final String addNewManageText;

  final String limitsTipText;

  final String manageTitleText;

  final String groupManageText;

  final String groupTypeTipText;

  final String feedbackListText;

  final String newFeedBackLabel;

  final String addMemberOrGroupText;

  final String searchContactsOrGroupText;

  final String supplementText;

  final String statusText;

  final String readText;
  final String unreadText;

  final String mySupplementText;

  final String copyTipText;

  final String selectOneChatText;

  final String transpondText;

  final String selectGroupText;

  final String createNewChatText;

  final String lateContactsText;

  final String atMostChatText;

  final String sendToText;

  final String addBannedMemberText;

  final String groupTypeSecretTipText;

  final String alreadyMemberText;

  final String pleaseSelectText;

  final String addUserText;

  final String replicatedText;

  final String sendFailText;

  final String sendingText;

  final String memberAlreadyText;

  final String replyText;

  final String copyText;

  final String asSaveText;

  final String asSaveDownloadText;

  final String deleteText;

  final String voiceMessageText;

  final String pictureMessageText;

  final String removeAdminText;

  final String titleText;

  final String immediatelyReconnectionText;

  final String connectingText;

  final String cleardialogueTipText;

  final String delOtherClearMessage;

  final String delAllClearMessage;

  final String messageNotFind;

  final String personText;

  final String selectCountryText;

  final String openText;

  final String deleteMessageTipText;

  final String deleteOtherMessageTipText;

  final String deleteAllMessageTipText;

  final String mediaText;

  final String linkText;

  final String secondReconnectionText;

  final String searchGroupMemberText;

  final String bannedConfirmTipText;

  final String groupNameLimitToast;

  final String draftText;

  final String forbiddenTimeText;

  final String selectForbiddenTimeText;

  final String forbiddenText;

  final String timeMinuteText;

  final String timeHourText;

  final String timeDayText;

  final String timePermanentText;

  final String customText;

  final String forbiddenToTimeText;

  final String cancelForbiddenText;

  final String feedbackContentTipText;

  final String feedbackSupplementText;

  final String onloadPictureLengthText;

  final String repliedText;

  final String finishedText;

  final String feedbackDetailText;

  final String registerText;

  final String accountTipText;

  final String passwordTipText;

  final String accountValidatorTipText;

  final String passwordValidatorTipText;

  final String accountValidatorNumTipText;

  final String passwordValidatorNumTipText;

  final String comfirmPasswordText;

  final String comfirmPasswordValidatorText;

  final String invitationText;

  final String myReplayText;

  final String serviceText;

  final String singleForbiddenText;

  final String singleForbiddenYearText;

  final String singleForbiddenMonthText;

  final String singleForbiddenDayText;

  final String singleForbiddenHourText;

  final String singleForbiddenMinuteText;

  final String singleForbiddenSecondText;

  final String addFriendNotice;

  final String addFriendNoticeText;

  final String serverErrorText;

  final String networkErrorText;

  final String reconnectText;

  final String underwayText;

  final String removeMemberByGroupText;

  final String enterFeedbackTitleTipText;

  final String enterFeedbackContentTipText;

  final String setMemberTipText;

  final String setManganeseTipText;

  final String videoCallPermission;

  final String videoStatusWaiting;

  final String videoStatusRequest;

  final String videoStatusAgree;

  final String videoStatusRefuse;

  final String videoStatusConnecting;

  final String videoStatusActive;

  final String videoStatusClose;

  final String videoStatusDisconnected;

  final String videoStatusCancel;

  final String videoStatusBusy;

  final String videoStatusNotAnswered;

  final String videoStatusFailed;

  final String downloadText;

  final String asSaveGalleryText;

  final String copyImageText;

  final String imageGallerySaverText;

  final String downloadSuccessText;

  final String openDirText;

  final String notFindVideoOrAudioDevice;

  final String notFindVideoDevice;

  final String notFindAudioDevice;

  final String videoStatusOther;

  final String deviceBusy;

  final String repeatLoginText;

  final String accountCodeTipText;

  final String skipText;

  // 简历模块
  final String onlineCV;

  final String nameText;

  final String advantage;

  final String jobExp;

  final String jobExpLocation;

  final String workExperience;

  final String JobRquirement;

  final String studyExperience;

  final String schoolName;

  final String majorName;

  final String richAdvantage;

  final String advantagePlaced;

  final String companyNameText;

  final String fillInText;

  final String profilePhoto;

  final String profilePhotoText;

  final String firstNameText;

  final String lastNameText;

  final String birthdateText;

  final String jobTimeText;

  final String workLife;

  final String ageText;

  final String jobSearchStatus;

  final String desiredPosition;

  final String desiredCity;

  final String desiredIndustry;

  final String desiredSalary;

  final String sureText;

  final String graduatedSchool;

  final String graduatedSchoolText;

  final String academincQualifications;

  final String specialty;

  final String jobDirectionText;

  final String lookNewJobTips;

  final String desiredPositionText;

  final String desiredCityText;

  final String desiredIndustryText;

  final String desiredMonthlySalaryText;

  final String findJobText;

  final String comeWorkAnyTimeTips;

  final String jobDetailsText;

  final String sendJobText;

  final String jobSeekInfoText;

  final String manText;

  final String womanText;

  final String timeParticipationWorkTips;

  final String nextStepText;

  final String specialtyText;

  final String academicQualificationsText;

  final String collegeNameText;

  final String jobForText;

  final String jobExpectationsText;

  final String educationalExperienceText;

  final String searchJobHereTips;

  final String searchJobTips;

  final String searchJobText;

  final String recentWorkExp;

  final String companyName;

  final String workingTime;

  final String entryTime;

  final String jobTitle;

  final String present;

  final String discoverText;

  final String companyTipText;

  final String prohibitSimulator;

  final String eduTipText;

  final String positionTipText;

  final String moneyTipText;

  final String accountOrPasswordError;

  final String setUp;

  final String versionText;

  final String password;


  static Languages of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  Languages({
    this.password = "密码",
    this.versionText = "版本",
    this.setUp = "设置",
    this.accountOrPasswordError = "账号或密码错误",
    this.prohibitSimulator = "禁止使用模拟器",
    this.discoverText = "Discover",
    this.present = "至今",
    this.sureText = "确认",
    this.skipText = "Skip",
    this.jobForText = "Jobs for {name}",
    this.manText = "Man",
    this.searchJobText = "Search jobs",
    this.searchJobTips = "Please enter criteria for the job you want to search",
    this.searchJobHereTips = "Search jobs here",
    this.educationalExperienceText = "Educational experience",
    this.collegeNameText = "College name",
    this.academicQualificationsText = "Academic qualifications",
    this.specialtyText = "Specialty",
    this.womanText = "Woman",
    this.jobExpectationsText = "Job expectations",
    this.nextStepText = "Next step",
    this.timeParticipationWorkTips = "Time of participation in work",
    this.jobSeekInfoText = "Job seeking info",
    this.jobDetailsText = "Job details",
    this.sendJobText = "Send job",
    this.findJobText = "Find a job",
    this.comeWorkAnyTimeTips = "Resigned, come to work at any time",
    this.desiredMonthlySalaryText = "Desired monthly salary",
    this.jobDirectionText = "Job direction",
    this.lookNewJobTips = "Already employed, looking for a new job",
    this.desiredPositionText = "Desired position",
    this.desiredCityText = "Desired city",
    this.desiredIndustryText = "Desired industry",
    // 简历模块
    this.positionTipText = '期望职位不能为空',
    this.eduTipText = '学校名称不能为空',
    this.moneyTipText = '期望月薪不能为空',

    this.companyTipText = '公司名称不能为空',
    this.companyName = '公司名称',
    this.workingTime = '工作起始时间',
    this.entryTime = 'Entry Time',
    this.jobTitle = '工作职称',
    this.recentWorkExp = "最近的工作经历",
    this.specialty = "专业",
    this.academincQualifications = "学历",
    this.graduatedSchoolText = "毕业院校",
    this.graduatedSchool = "院校名称",
    this.desiredSalary = "期望月薪(￥)",
    this.desiredIndustry = "期望行业",
    this.desiredCity = "期望城市",
    this.desiredPosition = "期望职位",
    this.jobSearchStatus = "求职状态",
    this.onlineCV = "我的在线简历",
    this.nameText = "姓名",
    this.advantage = "个人优势",
    this.jobExp = "求职期望",
    this.jobExpLocation = "期望职位,期望城市",
    this.workExperience = "工作经历",
    this.companyNameText = "这里是公司的名称",
    this.JobRquirement = "这里是工作职责",
    this.studyExperience = "教育经历",
    this.schoolName = "这里是院校名称",
    this.majorName = "学历·专业",
    this.fillInText = "请填写",
    this.richAdvantage = 'A rich introduction of personal advantages is more favored',
    this.advantagePlaced = 'Please fill in your personal strengths here',
    this.profilePhoto = 'Profile photo',
    this.profilePhotoText = "It is best to upload a real person's profile picture",
    this.firstNameText = 'First name',
    this.lastNameText = 'Last name',
    this.birthdateText = 'Birth date',
    this.jobTimeText = '工作经验',
    this.workLife = '{number}年经验',
    this.ageText = '{number}岁',
    this.repeatLoginText = "{account} 已在当前设备登录",
    this.accountCodeTipText = "Enter invitation code (optional)",
    this.deviceBusy = "正在通话中...",
    this.videoStatusOther = "已在其它设备处理",
    this.notFindVideoDevice = "未检测到摄像头",
    this.notFindVideoOrAudioDevice = "未检测到摄像头或麦克风",
    this.notFindAudioDevice = "未检测到麦克风",
    this.downloadSuccessText = "添加成功",
    this.openDirText = "打开所在目录",
    this.copyImageText = "复制图片",
    this.imageGallerySaverText = "保存失败，请同意写入相册权限",
    this.asSaveGalleryText = "保存到相册",
    this.downloadText = "下载",
    this.asSaveDownloadText = "保存到下载文件夹",
    this.asSaveText = "另存为",
    this.videoStatusFailed = "连接失败",
    this.videoStatusWaiting = "等待接听",
    this.videoStatusRequest = "请求通话",
    this.videoStatusAgree = "视频通话",
    this.videoStatusRefuse = "已拒绝",
    this.videoStatusConnecting = "通话中",
    this.videoStatusActive = "通话中",
    this.videoStatusClose = "已结束",
    this.videoStatusDisconnected = "已断开",
    this.videoStatusCancel = "已取消",
    this.videoStatusBusy = "繁忙",
    this.videoStatusNotAnswered = "未接听",
    this.videoCallPermission = "音视频通话，请允许使用摄像头和麦克风",
    this.removeMemberByGroupText = "您已被移除当前群聊",
    this.reconnectText = "重连",
    this.networkErrorText = "网络错误，请稍后再试",
    this.serverErrorText = "服务器内部错误，请稍后再试",
    this.addFriendNoticeText = "添加你为联系人",
    this.addFriendNotice = "{name}添加你为联系人",
    this.singleForbiddenText = "当前已被禁言",
    this.enterFeedbackTitleTipText = "请输入标题",
    this.setMemberTipText = "确定要设置为成员?",
    this.setManganeseTipText = "确定要设置为管理员?",
    this.enterFeedbackContentTipText = "请输入详细内容...",
    this.singleForbiddenYearText = "约{value}年后解除禁言",
    this.singleForbiddenMonthText = "约{value}月后解除禁言",
    this.singleForbiddenDayText = "约{value}天后解除禁言",
    this.singleForbiddenHourText = "约{value}时后解除禁言",
    this.singleForbiddenMinuteText = "约{value}分后解除禁言",
    this.singleForbiddenSecondText = "约{value}秒后解除禁言",
    this.cancelForbiddenText = "取消禁言",
    this.customText = "自定义",
    this.underwayText = "进行中",
    this.timePermanentText = "永久",
    this.timeDayText = "{day}天",
    this.timeHourText = "{hour}小时",
    this.timeMinuteText = "{minute}分钟",
    this.forbiddenToTimeText = "禁言至 yyyy/MM/dd HH:mm",
    this.forbiddenText = "禁言",
    this.selectForbiddenTimeText = "选择禁言时间",
    this.forbiddenTimeText = "禁言时间",
    this.draftText = "草稿",
    this.myReplayText = "我的回复",
    this.serviceText = "客服",
    this.onlyManageAddMember = "只允许管理员邀请成员",
    this.addMemberOrGroupText = "添加联系人",
    this.feedbackSupplementText = "反馈补充",
    this.feedbackDetailText = "反馈详情",
    this.registerText = "注册",
    this.onloadPictureLengthText = "已上传{num}张",
    this.finishedText = "已完结",
    this.accountValidatorTipText = "账号不能为空",
    this.invitationText = "请输入邀请码",
    this.accountValidatorNumTipText = "账号仅支持7~15位字母和数字",
    this.passwordValidatorNumTipText = "密码仅支持6~18位字母和数字",
    this.comfirmPasswordText = "请再次输入密码",
    this.comfirmPasswordValidatorText = "两次输入密码不一致",
    this.passwordValidatorTipText = "密码不能为空",
    this.repliedText = "已回复",
    this.accountTipText = "请输入账号",
    this.passwordTipText = "请输入密码",
    this.supplementText = "补充",
    this.bannedConfirmTipText = "您确定要封禁用户{name}吗?",
    this.feedbackContentTipText = "请输入详细内容",
    this.mediaText = "媒体",
    this.linkText = "链接",
    this.groupNameLimitToast = "群名称长度不能超过32个字符",
    this.searchGroupMemberText = "搜索群成员",
    this.secondReconnectionText = "秒后进行重连...",
    this.addBannedMemberText = "添加封禁用户",
    this.deleteMessageTipText = "您确定要删除此消息吗？",
    this.deleteOtherMessageTipText = "为对方删除消息",
    this.deleteAllMessageTipText = "为所有人删除消息",
    this.openText = "打开",
    this.groupTypeSecretTipText = "任何人仅可以通过被邀请加入私密群组",
    this.statusText = "状态：",
    this.selectCountryText = "选择国家",
    this.alreadyMemberText = "已读成员",
    this.replicatedText = "已复制",
    this.sendFailText = "发送失败",
    this.removeAdminText = "撤销管理员",
    this.delOtherClearMessage = "为对方清除消息",
    this.delAllClearMessage = "为所有人清除消息",
    this.immediatelyReconnectionText = "立即重连",
    this.personText = "{count}人",
    this.cleardialogueTipText = "您确定清除此对话的消息吗？",
    this.messageNotFind = "清除消息不可找回",
    this.connectingText = "连接中...",
    this.titleText = "头衔",
    this.copyText = "复制",
    this.deleteText = "删除",
    this.pictureMessageText = "图片消息",
    this.voiceMessageText = "语音消息",
    this.replyText = "回复",
    this.pleaseSelectText = "请选择",
    this.memberAlreadyText = "{num}人已读",
    this.copyTipText = "复制成功",
    this.addUserText = "添加用户",
    this.sendingText = "发送中",
    this.transpondText = "转发",
    this.selectGroupText = "选择群组",
    this.selectOneChatText = "选择一个聊天",
    this.createNewChatText = "创建新的聊天",
    this.lateContactsText = "最近联系人",
    this.atMostChatText = "最多选择10个聊天",
    this.sendToText = "发送给：",
    this.readText = "已读",
    this.unreadText = "未读",
    this.mySupplementText = "我的补充",
    this.searchContactsOrGroupText = "搜索联系人",
    this.voiceUnderTime = "说话时间太短",
    this.groupIntroductionHint = "暂无",
    this.exitGroupMemberTip = "{name} 退出了群聊",
    this.clearRecordsText = "清除记录",
    this.msgNotDisturbText = "消息免打扰",
    this.groupManageText = "群组管理员",
    this.operateTipText = "您正在对 {name} 进行操作",
    this.groupPhotoText = "群头像",
    this.feedbackListText = "反馈记录",
    this.newFeedBackLabel = "新建反馈",
    this.updateGroupInfoText = "修改群组信息",
    this.delGroupInfoText = "删除消息",
    this.groupTypeTipText = "任何人都可以搜索和加入公开群",
    this.memberInteractSetText = "成员互动设置",
    this.manageTitleText = "给管理员一个头衔",
    this.limitsTipText = "管理员将其他群员设为管理员，将赋予新管理员与自己相同的权限",
    this.addNewManageText = "添加新管理员",
    this.bannedUserSetText = "封禁用户设置",
    this.bannedToPostSetText = "禁言设置",
    this.memberLimitsSetText = "群成员权限修改",
    this.bannedMemberLengthText = "{number}位已封禁用户",
    this.bannedMemberTipText = "被封禁的用户将无法通过邀请和搜索加入群组",
    this.enterGroupText = "进入群聊",
    this.updateManageLimitsText = "修改管理员权限",
    this.inviteText = "邀请",
    this.publicText = "公开",
    this.removeText = "移除",
    this.privateText = "私有",
    this.groupTypeText = "群组类型",
    this.groupLinkText = "群组链接",
    this.bannedMemberText = "封禁用户",
    this.voiceText = "语音",
    this.chatRecordsCountText = "{count}条相关的聊天记录",
    this.clearChatRecordsTipText = "确定要清除和{name}聊天记录?",
    this.groupNameText = "群名称",
    this.groupIntroText = "群简介",
    this.addNewCircleText = "添加圈子",
    this.twoWayRevokeTipText = "撤回数据多次覆盖删除，不可恢复",
    this.moreSecureText = "安全加密聊天",
    this.moreSecureTipText = "信息端对端加密处理，聊天更安全",
    this.privateManagementTipText = "私钥仅存放在用户移动端设备中",
    this.privateManagementText = '私钥管理',
    this.twoWayRevokeText = '双向撤回',
    this.pinnedConversationText = "置顶会话",
    this.cancelPinnedConversationText = "取消置顶",
    this.addCircleTipText = "请输入圈子ID",
    this.msgTurnOnText = "消息开启",
    this.groupMemberCountText = "{count} 人",
    this.removeGroupMemberTip = "{optName} 将 {names} 移除了群聊",
    this.addGroupMemberTip = "{optName} 邀请 {names} 加入了群聊",
    this.editGroupInfoTip = "{name}修改了群组信息",
    this.shareLinkTip = "分享连接已复制剪粘板",
    this.noCircleTipText = "您还没有添加圈子",
    this.joinCircleTipText = "快去添加试试",
    this.myCircleText = "我的圈子",
    this.circleSwitchTipText = "切换圈子后将无法接收当前圈子的消息",
    this.backText = "返回",
    this.circleJoinNumberText = "{number}已加入",
    this.searchCountText = "{count}条消息",
    this.pageSearchHint = "聊天记录/联系人/群",
    this.microphonePermissionTipText = "需要麦克风权限才能录音",
    this.reloadLoginTipText = "当前设备登录失效，请重新登录",
    this.nowExperienceTipText = "立即体验",
    this.myCreateGroupText = "我创建的",
    this.myManageGroupText = "我管理的",
    this.myJoinGroupText = "我加入的",
    this.logAgainText = "重新登录",
    this.msgClearTipText = "消息记录已清除",
    this.memberIdentityMember = "管理员",
    this.memberIdentityFounder = "创建者",
    this.addMemberToast = "添加成功",
    this.photographersText = "拍照",
    this.delConfirmTipText = "确认要删除用户{name}",
    this.enterCodeText = "输入验证码",
    this.shieldSuccessText = "屏蔽成功",
    this.cancelSuccessText = "取消成功",
    this.shieldConfirmTipText = "确认要屏蔽用户{name}",
    this.newFriendsText = "新的朋友",
    this.forbidSendIconText = "当前群禁止发送图片",
    this.addSuccessText = "已添加成功",
    this.modifyPhotoText = "修改头像",
    this.cacheClearTipText = "缓存已清除",
    this.notFilledText = "未填写",
    this.submitButtonLabel = "提交",
    this.cacheTipText = '您确定要清除缓存？',
    this.loadingText = "正在加载...",
    this.briefIntroductionTipText = "不能超过60个字符",
    this.feedbackTitleTip = "标题不能为空",
    this.feedbackTitleText = "标题",
    this.feedbackContentText = "内容",
    this.nicknameTipText = "请输入昵称",
    this.mobileDataTipText = "图片,视频10M，文件1M",
    this.inpNicknameCorrectTipText = "请输入正确的昵称",
    this.feedbackContentTip = "内容不能为空",
    this.exitGroupTip = "确认要退出组群 {name}",
    this.cancelMemberTip = "确认删除成员 {name}",
    this.clearMsgRecordIp = "确认要清除 {name} 的消息记录",
    this.dissolveGroupTip = "确认要解散组群 {name}",
    this.noMoreResultText = "没有更多搜索结果",
    this.phoneSelPicture = "从手机相册选择",
    this.versionTips = '当前是最新版本',
    this.adverseDelSuccessTip = "对话删除成功",
    this.groupManagementText = "群组管理",
    this.dissolveButtonLabel = "解散",
    this.dissolveGroupText = "解散群组",
    this.endTimeText = "结束时间",
    this.startTimeText = "开始时间",
    this.allBannedText = "全员禁言",
    this.bannedSetText = "禁言设置",
    this.allowSendFileText = "允许发送文件",
    this.allowSendText = "允许发送文字",
    this.allowSendVoiceText = "允许发送语音",
    this.allowSendPictureText = "允许发送图片",
    this.msgLimitsText = "消息权限",
    this.forbidInGroupAddTip = "禁止通过群组添加联系人",
    this.memberAndInvisible = "成员彼此不可见",
    this.memberInteractText = "成员互动",
    this.newMemberJoinNotTip = "新成员入群提示不可见",
    this.joinSetText = "加入设置",
    this.memberLookMsgTip = "新成员查看100条历史消息",
    this.tipText = "提示",
    this.clearButtonLabel = "清除",
    this.cancelText = "取消",
    this.editGroupInfoText = "编辑群信息",
    this.groupInRemove = "从群组中移除",
    this.setMemberText = "设置为成员",
    this.setManganeseText = "设置为管理员",
    this.delExitGroupText = "删除并退出群",
    this.informationText = "简介",
    this.groupMemberText = "群组成员",
    this.inviteMemberText = "邀请新成员",
    this.groupIntroduceText = "这是组群的介绍",
    this.searchInputText = "昵称/ID/手机号",
    this.editText = "编辑",
    this.inviteLinkText = "邀请链接",
    this.clearOnlineRecordText = "清空聊天记录",
    this.searchOnlineRecordText = "查找聊天记录",
    this.managementGroupText = "管理群组",
    this.selGroupPicture = "请选择组群图片",
    this.editGroupPhotoText = "点击编辑群头像",
    this.inputGroupNameText = "请输入组群名称",
    this.setGroupPictureText = "设置群图片",
    this.refuseText = "拒绝",
    this.agreementText = "同意",
    this.hasAgreedText = "已同意",
    this.hasRefuseText = "已拒绝",
    this.addSuccessFriendText = "成功添加好友",
    this.addAgreeFriendText = "已同意添加好友",
    this.addRefuseFriendText = "已拒绝添加好友",
    this.searchContactsText = "搜索联系人",
    this.clearedHistoryListText = "历史记录已清除",
    this.personalizedSignatureText = "该用户什么都没留下~",
    this.forbidSendTxtText = "当前群禁止发送文本消息",
    this.forbidSendVoiceText = "当前群禁止发送语音",
    this.notOnlineText = "不在线",
    this.allSilenceText = "全体禁言",
    this.forbidSendFileText = "当前群禁止发送文件",
    this.groupInfoNumberText = "{number}位成员，{online}人在线",
    this.inputGroupNameToast = "请输入群名称",
    this.selectGroupAvatarToast = "请选择群头像",
    this.inputGroupNameHint = "请输入群名",
    this.loginPhoneTipText = "请输入正确的手机号码",
    this.loginCodeTipText = "验证码发送成功",
    this.getCodeTipText = "获取验证码",
    this.countdownText = "{number}s后重新获取",
    this.codeErrorTipText = "请输入6位的验证码",
    this.updateSuccessText = "成功",
    this.presentDeviceText = "当前设备",
    this.lastLoginTimeText = "最后上线时间：",
    this.retainMonthText = "{number}个月",
    this.fileStorageTimeMonthText = "一个月",
    this.fileStorageThreeDaysText = "三天",
    this.fileStorageWeekendText = "一周",
    this.fileStorageForeverText = "永久",
    this.cancelShieldText = "取消屏蔽",
    this.shieldUserLengthText = "{number}位已屏蔽用户",
    this.mediaTypeText = "媒体类型",
    this.userAgreementText = "用户协议",
    this.PrivacyAgreement = "隐私协议",
    this.everyoneText = "所有人",
    this.myContactText = "我的联系人",
    this.hideText = "隐藏",
    this.deviceOtherQuitTipText = "将其他设备退出登录",
    this.onlineText = "在线",
    this.scanQRCodeText = "扫描二维码",
    this.deviceQuitTipText = "退出所有已登录的设备，只保留当前使用的",
    this.othersDeviceText = "其他设备",
    this.maskedUsersText = "屏蔽用户",
    this.maskedUsersTipText = "被屏蔽的用户将无法与你联系",
    this.unknownText = "未知",
    this.pictureText = "图片",
    this.pictureMobileTipText = "对所有对话启用",
    this.videoMobileTipText = "对所有对话不超过10.0MB",
    this.fileMobileTipText = "对所有对话不超过1.0MB",
    this.fileText = "文件",
    this.videoText = "视频",
    this.audioTextCall = "语音通话",
    this.videoTextCall = "视频通话",
    this.addFriendText = "添加到联系人",
    this.exitText = "退出",
    this.cancelRecording = "手指上滑，取消发送",
    this.recordingStartButtonText = "按住说话",
    this.recordingEndButtonText = "松开结束",
    this.feedbackText = "意见反馈",
    this.circleTipText = "请输入圈子ID",
    this.circleAddText = "添加圈子",
    this.circleEnterText = "进入圈子",
    this.addText = "添加",
    this.female = "女",
    this.maleText = "男",
    this.saveText = "保存",
    this.circleText = "圈子",
    this.screenShotTipText = "私聊会话时IOS截屏通知；Android禁止截屏",
    this.screenshotsManagementText = "截屏管理",
    this.banScreenshotsText = "禁止截屏",
    this.mobileDataText = "移动数据",
    this.automaticallyDownload = "自动下载",
    this.wifiTipText = "图片,视频,文件",
    this.wifiText = "Wi-Fi",
    this.clearingLocalDataText = "清除本地数据",
    this.clearCacheText = "清除缓存",
    this.accountText = "账户",
    this.fileStorageTimeText = "文件存储时间",
    this.onOneIsAllowedText = "不允许任何人",
    this.dataUsageText = "数据用量",
    this.storageUsageText = "存储使用情况",
    this.accountRetentionPeriodText = "账户保留期限",
    this.equipmentText = "设备",
    this.loginEquipmentText = "已登录设备",
    this.blacklistText = "黑名单",
    this.shieldUserText = "已屏蔽用户",
    this.finallyOnLineIdleText = "最后上线 & 下线",
    this.invitationPermissionControlText = "邀请权限控制",
    this.personalInformationText = "个人信息",
    this.holderText = "所有人",
    this.privateChatText = "私聊",
    this.briefIntroductionText = "个性签名",
    this.dialogueInformText = "对话通知",
    this.backstageServiceText = "后台服务",
    this.backstageServiceTipText = "当应用被终止时自动重启后台服务，确保及时收到通知",
    this.backgroundNetworkConnectionText = "后台网络连接",
    this.backgroundNetworkConnectionTipText = "保持一个与服务器的低功耗后台网络连接以获得可靠的通知",
    this.voicePromptText = "发语音提示",
    this.vibrationText = "应用内振动",
    this.receivingPromptToneText = "应用内提示音",
    this.applicationNotificationText = "应用类通知",
    this.otherText = "其他",
    this.clickText = "点击",
    this.nicknameText = "昵称",
    this.genderText = "性别",
    this.idText = "ID",
    this.headPortraitText = "头像",
    this.personalDataText = "个人资料",
    this.favoriteText = "收藏夹",
    this.notificationAndSoundText = "通知和声音",
    this.privacyAndSecurityText = "隐私和安全",
    this.dataStorageText = "数据和存储",
    this.languageText = "语言",
    this.aboutUsText = "关于我们",
    this.versionUpdateText = "版本更新",
    this.shareAppText = "分享应用",
    this.inputMsgHintText = "输入消息，显示发送按钮",
    this.sendText = "发送",
    this.newFriendText = "新朋友",
    this.loginPageCodeText = "验证码已发送到您的手机",
    this.remarksText = "备注",
    this.loginPageCodeNum = "6位数字验证码",
    this.nextButton = "下一步",
    this.loginPagePhoneInput = "手机号码",
    this.loginPagePhoneText = "输入手机号码创建账户并登录",
    this.loginButtonLabel = "登录",
    this.loginText = "登录",
    this.changeLanguage = "修改语言",
    this.selectLanguages = "选择语言",
    this.okButtonLabel = "确定",
    this.cancelButtonLabel = "取消",
    this.messageText = "消息",
    this.contactsText = "联系人",
    this.seeMoreText = "查看更多",
    this.groupText = "群组",
    this.chatRecordText = "聊天记录",
    this.deleteConversation = "删除对话",
    this.deleteConversationText = "删除对话同时将删除聊天记录",
    this.clearHistory = "清空历史记录",
    this.clearHistoryText = "你确定要删除所选对话的历史记录吗",
    this.pageSearchMessage = "聊天记录",
    this.pageSearchFriend = "联系人",
    this.pageSearchGroup = "群",
    this.searchText = "搜索",
    this.friend = "联系人",
    this.newGroupText = "新建群组",
    this.newEncryptedConversation = "新建加密会话",
    this.newContactText = "新建会话",
    this.newSecretContactText = "新建加密会话",
    this.newGroupContactText = "新建群组",
    this.addMemberText = "添加联系人",
    this.onlineStatusText = "在线状态",
    this.phoneText = "手机",
    this.clearChatRecordsText = "清空聊天记录",
    this.viewChatRecordsText = "查看聊天记录",
    this.toppingText = "置顶",
    this.noticeText = "通知",
    this.sendMessageText = "发消息",
    this.addContactText = "添加联系人",
    this.editContactText = "编辑联系人",
    this.removeContactText = "删除联系人",
    this.stopContactText = "屏蔽用户",
    this.pageChatDate = "MM月dd日 HH:mm",
    this.pageChatTime = "HH:mm",
    this.contactText = "联系人",
    this.myGroupText = "我的群组",
  });


  factory Languages.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return Languages(
      loginButtonLabel: map['loginButtonLabel']?.toString(),
      contactText: map['contactText']?.toString(),
      myGroupText: map['myGroupText']?.toString(),
      changeLanguage: map['changeLanguage']?.toString(),
      selectLanguages: map['selectLanguages']?.toString(),
      okButtonLabel: map['okButtonLabel']?.toString(),
      cancelButtonLabel: map['cancelButtonLabel']?.toString(),
      messageText: map['messageText']?.toString(),
      contactsText: map['contactsText']?.toString(),
      seeMoreText: map['seeMoreText']?.toString(),
      groupText: map['groupText']?.toString(),
      chatRecordText: map['chatRecordText']?.toString(),
      deleteConversationText: map['deleteConversationText']?.toString(),
      deleteConversation: map['deleteConversation']?.toString(),
      clearHistory: map['clearHistory']?.toString(),
      clearHistoryText: map['clearHistoryText']?.toString(),
      pageSearchMessage: map['pageSearchMessage']?.toString(),
      pageSearchFriend: map['pageSearchFriend']?.toString(),
      pageSearchGroup: map['pageSearchGroup']?.toString(),
      searchText: map['searchText']?.toString(),
      friend: map['friend']?.toString(),
      newGroupText: map['newGroupText']?.toString(),
      newEncryptedConversation: map['newEncryptedConversation']?.toString(),
      newContactText: map['newContactText']?.toString(),
      newSecretContactText: map['newSecretContactText']?.toString(),
      newGroupContactText: map['newGroupContactText']?.toString(),
      addMemberText: map['addMemberText']?.toString(),
      onlineStatusText: map['onlineStatusText']?.toString(),
      phoneText: map['phoneText']?.toString(),
      clearChatRecordsText: map['clearChatRecordsText']?.toString(),
      viewChatRecordsText: map['viewChatRecordsText']?.toString(),
      toppingText: map['toppingText']?.toString(),
      noticeText: map['noticeText']?.toString(),
      sendMessageText: map['sendMessageText']?.toString(),
      addContactText: map['addContactText']?.toString(),
      editContactText: map['editContactText']?.toString(),
      removeContactText: map['removeContactText']?.toString(),
      stopContactText: map['stopContactText']?.toString(),
      loginText: map['loginText']?.toString(),
      loginPagePhoneText: map['loginPagePhoneText']?.toString(),
      loginPageCodeText: map['loginPageCodeText']?.toString(),
      loginPagePhoneInput: map['loginPagePhoneInput']?.toString(),
      loginPageCodeNum: map['loginPageCodeNum']?.toString(),
      nextButton: map['nextButton']?.toString(),
      pageChatDate: map['pageChatDate']?.toString(),
      pageChatTime: map['pageChatTime']?.toString(),
      remarksText: map['remarksText']?.toString(),
      newFriendText: map['newFriendText']?.toString(),
      sendText: map['sendText']?.toString(),
      inputMsgHintText: map['inputMsgHintText']?.toString(),
      recordingStartButtonText: map['recordingStartButtonText']?.toString(),
      recordingEndButtonText: map['recordingEndButtonText']?.toString(),
      cancelRecording: map['cancelRecording']?.toString(),
      feedbackText: map['feedbackText']?.toString(),
      shareAppText: map['shareAppText']?.toString(),
      versionUpdateText: map['versionUpdateText']?.toString(),
      aboutUsText: map['aboutUsText']?.toString(),
      languageText: map['languageText']?.toString(),
      dataStorageText: map['dataStorageText']?.toString(),
      privacyAndSecurityText: map['privacyAndSecurityText']?.toString(),
      notificationAndSoundText: map['notificationAndSoundText']?.toString(),
      favoriteText: map['favoriteText']?.toString(),
      personalDataText: map['personalDataText']?.toString(),
      headPortraitText: map['headPortraitText']?.toString(),
      idText: map['idText']?.toString(),
      nicknameText: map['nicknameText']?.toString(),
      genderText: map['genderText']?.toString(),
      privateChatText: map['privateChatText']?.toString(),
      clickText: map['clickText']?.toString(),
      dialogueInformText: map['dialogueInformText']?.toString(),
      otherText: map['otherText']?.toString(),
      applicationNotificationText: map['applicationNotificationText']?.toString(),
      receivingPromptToneText: map['receivingPromptToneText']?.toString(),
      vibrationText: map['vibrationText']?.toString(),
      voicePromptText: map['voicePromptText']?.toString(),
      backstageServiceText: map['backstageServiceText']?.toString(),
      backstageServiceTipText: map['backstageServiceTipText']?.toString(),
      backgroundNetworkConnectionText: map['backgroundNetworkConnectionText']?.toString(),
      backgroundNetworkConnectionTipText: map['backgroundNetworkConnectionTipText']?.toString(),
      briefIntroductionText: map['briefIntroductionText']?.toString(),
      finallyOnLineIdleText: map['finallyOnLineIdleText']?.toString(),
      invitationPermissionControlText: map['invitationPermissionControlText']?.toString(),
      holderText: map['holderText']?.toString(),
      personalInformationText: map['personalInformationText']?.toString(),
      blacklistText: map['blacklistText']?.toString(),
      shieldUserText: map['shieldUserText']?.toString(),
      equipmentText: map['equipmentText']?.toString(),
      loginEquipmentText: map['loginEquipmentText']?.toString(),
      accountText: map['accountText']?.toString(),
      accountRetentionPeriodText: map['accountRetentionPeriodText']?.toString(),
      dataUsageText: map['dataUsageText']?.toString(),
      storageUsageText: map['storageUsageText']?.toString(),
      onOneIsAllowedText: map['onOneIsAllowedText']?.toString(),
      fileStorageTimeText: map['fileStorageTimeText']?.toString(),
      clearCacheText: map['clearCacheText']?.toString(),
      clearingLocalDataText: map['clearingLocalDataText']?.toString(),
      wifiText: map['wifiText']?.toString(),
      wifiTipText: map['wifiTipText']?.toString(),
      mobileDataText: map['mobileDataText']?.toString(),
      automaticallyDownload: map['automaticallyDownload']?.toString(),
      addFriendText: map['addFriendText']?.toString(),
      inputGroupNameHint: map['inputGroupNameHint']?.toString(),
      selectGroupAvatarToast: map['selectGroupAvatarToast']?.toString(),
      inputGroupNameToast: map['inputGroupNameToast']?.toString(),
      groupInfoNumberText: map['groupInfoNumberText']?.toString(),
      screenshotsManagementText: map['screenshotsManagementText']?.toString(),
      banScreenshotsText: map['banScreenshotsText']?.toString(),
      screenShotTipText: map['screenShotTipText']?.toString(),
      circleText: map['circleText']?.toString(),
      saveText: map['saveText']?.toString(),
      maleText: map['maleText']?.toString(),
      female: map['female']?.toString(),
      addText: map['addText']?.toString(),
      circleTipText: map['circleTipText']?.toString(),
      circleAddText: map['circleAddText']?.toString(),
      circleEnterText: map['circleEnterText']?.toString(),
      addMemberToast: map['addMemberToast']?.toString(),
      memberIdentityFounder: map['memberIdentityFounder']?.toString(),
      memberIdentityMember: map['memberIdentityMember']?.toString(),
      exitText: map['exitText']?.toString(),
      maskedUsersText: map['maskedUsersText']?.toString(),
      pictureText: map['pictureText']?.toString(),
      videoText: map['videoText']?.toString(),
      videoTextCall: map['videoTextCall']?.toString(),
      audioTextCall: map['audioTextCall']?.toString(),
      fileText: map['fileText']?.toString(),
      pictureMobileTipText: map['pictureMobileTipText']?.toString(),
      videoMobileTipText: map['videoMobileTipText']?.toString(),
      fileMobileTipText: map['fileMobileTipText']?.toString(),
      unknownText: map['unknownText']?.toString(),
      maskedUsersTipText: map['maskedUsersTipText']?.toString(),
      presentDeviceText: map['presentDeviceText']?.toString(),
      othersDeviceText: map['othersDeviceText']?.toString(),
      scanQRCodeText: map['scanQRCodeText']?.toString(),
      deviceQuitTipText: map['deviceQuitTipText']?.toString(),
      deviceOtherQuitTipText: map['deviceOtherQuitTipText']?.toString(),
      onlineText: map['onlineText']?.toString(),
      updateSuccessText: map['updateSuccessText']?.toString(),
      everyoneText: map['everyoneText']?.toString(),
      myContactText: map['myContactText']?.toString(),
      hideText: map['hideText']?.toString(),
      lastLoginTimeText: map['lastLoginTimeText']?.toString(),
      retainMonthText: map['retainMonthText']?.toString(),
      fileStorageTimeMonthText: map['fileStorageTimeMonthText']?.toString(),
      fileStorageThreeDaysText: map['fileStorageThreeDaysText']?.toString(),
      fileStorageWeekendText: map['fileStorageWeekendText']?.toString(),
      fileStorageForeverText: map['fileStorageForeverText']?.toString(),
      userAgreementText: map['userAgreementText']?.toString(),
      PrivacyAgreement: map['PrivacyAgreement']?.toString(),
      loginPhoneTipText: map['loginPhoneTipText']?.toString(),
      loginCodeTipText: map['loginCodeTipText']?.toString(),
      getCodeTipText: map['getCodeTipText']?.toString(),
      countdownText: map['countdownText']?.toString(),
      codeErrorTipText: map['codeErrorTipText']?.toString(),
      cancelShieldText: map['cancelShieldText']?.toString(),
      shieldUserLengthText: map['shieldUserLengthText']?.toString(),
      mediaTypeText: map['mediaTypeText']?.toString(),
      allSilenceText: map['allSilenceText']?.toString(),
      photographersText: map['photographersText']?.toString(),
      forbidSendTxtText: map['forbidSendTxtText']?.toString(),
      forbidSendIconText: map['forbidSendIconText']?.toString(),
      forbidSendFileText: map['forbidSendFileText']?.toString(),
      forbidSendVoiceText: map['forbidSendVoiceText']?.toString(),
      notOnlineText: map['notOnlineText']?.toString(),
      modifyPhotoText: map['modifyPhotoText']?.toString(),
      addSuccessText: map['addSuccessText']?.toString(),
      personalizedSignatureText: map['personalizedSignatureText']?.toString(),
      clearedHistoryListText: map['clearedHistoryListText']?.toString(),
      newFriendsText: map['newFriendsText']?.toString(),
      agreementText: map['agreementText']?.toString(),
      refuseText: map['refuseText']?.toString(),
      hasAgreedText: map['hasAgreedText']?.toString(),
      hasRefuseText: map['hasRefuseText']?.toString(),
      addSuccessFriendText: map['addSuccessFriendText']?.toString(),
      addAgreeFriendText: map['addAgreeFriendText']?.toString(),
      addRefuseFriendText: map['addRefuseFriendText']?.toString(),
      searchContactsText: map['searchContactsText']?.toString(),
      editText: map['editText']?.toString(),
      setGroupPictureText: map['setGroupPictureText']?.toString(),
      groupIntroduceText: map['groupIntroduceText']?.toString(),
      editGroupPhotoText: map['editGroupPhotoText']?.toString(),
      inputGroupNameText: map['inputGroupNameText']?.toString(),
      selGroupPicture: map['selGroupPicture']?.toString(),
      informationText: map['informationText']?.toString(),
      searchInputText: map['searchInputText']?.toString(),
      managementGroupText: map['managementGroupText']?.toString(),
      searchOnlineRecordText: map['searchOnlineRecordText']?.toString(),
      clearOnlineRecordText: map['clearOnlineRecordText']?.toString(),
      inviteLinkText: map['inviteLinkText']?.toString(),
      inviteMemberText: map['inviteMemberText']?.toString(),
      groupMemberText: map['groupMemberText']?.toString(),
      editGroupInfoText: map['editGroupInfoText']?.toString(),
      delExitGroupText: map['delExitGroupText']?.toString(),
      setManganeseText: map['setManganeseText']?.toString(),
      setMemberText: map['setMemberText']?.toString(),
      groupInRemove: map['groupInRemove']?.toString(),
      tipText: map['tipText']?.toString(),
      cancelText: map['cancelText']?.toString(),
      clearButtonLabel: map['clearButtonLabel']?.toString(),
      groupManagementText: map['groupManagementText']?.toString(),
      joinSetText: map['joinSetText']?.toString(),
      memberLookMsgTip: map['memberLookMsgTip']?.toString(),
      newMemberJoinNotTip: map['newMemberJoinNotTip']?.toString(),
      memberInteractText: map['memberInteractText']?.toString(),
      memberAndInvisible: map['memberAndInvisible']?.toString(),
      forbidInGroupAddTip: map['forbidInGroupAddTip']?.toString(),
      onlyManageAddMember: map['onlyManageAddMember']?.toString(),
      msgLimitsText: map['msgLimitsText']?.toString(),
      allowSendText: map['allowSendText']?.toString(),
      allowSendPictureText: map['allowSendPictureText']?.toString(),
      allowSendVoiceText: map['allowSendVoiceText']?.toString(),
      allowSendFileText: map['allowSendFileText']?.toString(),
      bannedSetText: map['bannedSetText']?.toString(),
      allBannedText: map['allBannedText']?.toString(),
      startTimeText: map['startTimeText']?.toString(),
      endTimeText: map['endTimeText']?.toString(),
      dissolveGroupText: map['dissolveGroupText']?.toString(),
      dissolveButtonLabel: map['dissolveButtonLabel']?.toString(),
      adverseDelSuccessTip: map['adverseDelSuccessTip']?.toString(),
      versionTips: map['versionTips']?.toString(),
      phoneSelPicture: map['phoneSelPicture']?.toString(),
      loadingText: map['loadingText']?.toString(),
      noMoreResultText: map['noMoreResultText']?.toString(),
      exitGroupTip: map['exitGroupTip']?.toString(),
      cancelMemberTip: map['cancelMemberTip']?.toString(),
      clearMsgRecordIp: map['clearMsgRecordIp']?.toString(),
      dissolveGroupTip: map['dissolveGroupTip']?.toString(),
      feedbackTitleTip: map['feedbackTitleTip']?.toString(),
      feedbackContentTip: map['feedbackContentTip']?.toString(),
      feedbackTitleText: map['feedbackTitleText']?.toString(),
      feedbackContentText: map['feedbackContentText']?.toString(),
      nicknameTipText: map['nicknameTipText']?.toString(),
      inpNicknameCorrectTipText: map['inpNicknameCorrectTipText']?.toString(),
      mobileDataTipText: map['mobileDataTipText']?.toString(),
      cacheClearTipText: map['cacheClearTipText']?.toString(),
      cacheTipText: map['cacheTipText']?.toString(),
      submitButtonLabel: map['submitButtonLabel']?.toString(),
      notFilledText: map['notFilledText']?.toString(),
      pageSearchHint: map['pageSearchHint']?.toString(),
      enterCodeText: map['enterCodeText']?.toString(),
      briefIntroductionTipText: map['briefIntroductionTipText']?.toString(),
      shieldSuccessText: map['shieldSuccessText']?.toString(),
      cancelSuccessText: map['cancelSuccessText']?.toString(),
      delConfirmTipText: map['delConfirmTipText']?.toString(),
      shieldConfirmTipText: map['shieldConfirmTipText']?.toString(),
      searchCountText: map['searchCountText']?.toString(),
      shareLinkTip: map['shareLinkTip']?.toString(),
      editGroupInfoTip: map['editGroupInfoTip']?.toString(),
      addGroupMemberTip: map['addGroupMemberTip']?.toString(),
      removeGroupMemberTip: map['removeGroupMemberTip']?.toString(),
      microphonePermissionTipText: map['microphonePermissionTipText']?.toString(),
      msgClearTipText: map['msgClearTipText']?.toString(),
      nowExperienceTipText: map['nowExperienceTipText']?.toString(),
      reloadLoginTipText: map['reloadLoginTipText']?.toString(),
      logAgainText: map['logAgainText']?.toString(),
      myCreateGroupText: map['myCreateGroupText']?.toString(),
      myManageGroupText: map['myManageGroupText']?.toString(),
      myJoinGroupText: map['myJoinGroupText']?.toString(),
      groupMemberCountText: map['groupMemberCountText']?.toString(),
      groupIntroductionHint: map['groupIntroductionHint']?.toString(),
      exitGroupMemberTip: map['exitGroupMemberTip']?.toString(),
      noCircleTipText: map['noCircleTipText']?.toString(),
      joinCircleTipText: map['joinCircleTipText']?.toString(),
      myCircleText: map['myCircleText']?.toString(),
      circleJoinNumberText: map['circleJoinNumberText']?.toString(),
      backText: map['backText']?.toString(),
      circleSwitchTipText: map['circleSwitchTipText']?.toString(),
      voiceUnderTime: map['voiceUnderTime']?.toString(),
      clearRecordsText: map['clearRecordsText']?.toString(),
      msgNotDisturbText: map['msgNotDisturbText']?.toString(),
      msgTurnOnText: map['msgTurnOnText']?.toString(),
      pinnedConversationText: map['pinnedConversationText']?.toString(),
      operateTipText: map['operateTipText']?.toString(),
      cancelPinnedConversationText: map['cancelPinnedConversationText']?.toString(),
      addCircleTipText: map['addCircleTipText']?.toString(),
      groupPhotoText: map['groupPhotoText']?.toString(),
      groupNameText: map['groupNameText']?.toString(),
      groupIntroText: map['groupIntroText']?.toString(),
      addNewCircleText: map['addNewCircleText']?.toString(),
      privateManagementText: map['privateManagementText']?.toString(),
      privateManagementTipText: map['privateManagementTipText']?.toString(),
      twoWayRevokeText: map['twoWayRevokeText']?.toString(),
      twoWayRevokeTipText: map['twoWayRevokeTipText']?.toString(),
      moreSecureText: map['moreSecureText']?.toString(),
      moreSecureTipText: map['moreSecureTipText']?.toString(),
      clearChatRecordsTipText: map['clearChatRecordsTipText']?.toString(),
      inviteText: map['inviteText']?.toString(),
      enterGroupText: map['enterGroupText']?.toString(),
      chatRecordsCountText: map['chatRecordsCountText']?.toString(),
      voiceText: map['voiceText']?.toString(),
      groupTypeText: map['groupTypeText']?.toString(),
      groupLinkText: map['groupLinkText']?.toString(),
      bannedMemberText: map['bannedMemberText']?.toString(),
      publicText: map['publicText']?.toString(),
      privateText: map['privateText']?.toString(),
      bannedMemberLengthText: map['bannedMemberLengthText']?.toString(),
      bannedMemberTipText: map['bannedMemberTipText']?.toString(),
      removeText: map['removeText']?.toString(),
      updateManageLimitsText: map['updateManageLimitsText']?.toString(),
      updateGroupInfoText: map['updateGroupInfoText']?.toString(),
      delGroupInfoText: map['delGroupInfoText']?.toString(),
      memberInteractSetText: map['memberInteractSetText']?.toString(),
      memberLimitsSetText: map['memberLimitsSetText']?.toString(),
      bannedToPostSetText: map['bannedToPostSetText']?.toString(),
      bannedUserSetText: map['bannedUserSetText']?.toString(),
      addNewManageText: map['addNewManageText']?.toString(),
      limitsTipText: map['limitsTipText']?.toString(),
      manageTitleText: map['manageTitleText']?.toString(),
      groupManageText: map['groupManageText']?.toString(),
      groupTypeTipText: map['groupTypeTipText']?.toString(),
      feedbackListText: map['feedbackListText']?.toString(),
      newFeedBackLabel: map['newFeedBackLabel']?.toString(),
      addMemberOrGroupText: map['addMemberOrGroupText']?.toString(),
      searchContactsOrGroupText: map['searchContactsOrGroupText']?.toString(),
      supplementText: map['supplementText']?.toString(),
      statusText: map['statusText']?.toString(),
      readText: map['readText']?.toString(),
      unreadText: map['unreadText']?.toString(),
      mySupplementText: map['mySupplementText']?.toString(),
      copyTipText: map['copyTipText']?.toString(),
      selectOneChatText: map['selectOneChatText']?.toString(),
      transpondText: map['transpondText']?.toString(),
      selectGroupText: map['selectGroupText']?.toString(),
      createNewChatText: map['createNewChatText']?.toString(),
      lateContactsText: map['lateContactsText']?.toString(),
      atMostChatText: map['atMostChatText']?.toString(),
      sendToText: map['sendToText']?.toString(),
      addBannedMemberText: map['addBannedMemberText']?.toString(),
      groupTypeSecretTipText: map['groupTypeSecretTipText']?.toString(),
      alreadyMemberText: map['alreadyMemberText']?.toString(),
      pleaseSelectText: map['pleaseSelectText']?.toString(),
      addUserText: map['addUserText']?.toString(),
      replicatedText: map['replicatedText']?.toString(),
      sendFailText: map['sendFailText']?.toString(),
      sendingText: map['sendingText']?.toString(),
      memberAlreadyText: map['memberAlreadyText']?.toString(),
      replyText: map['replyText']?.toString(),
      copyText: map['copyText']?.toString(),
      asSaveText: map['asSaveText']?.toString(),
      asSaveDownloadText: map['asSaveDownloadText']?.toString(),
      deleteText: map['deleteText']?.toString(),
      voiceMessageText: map['voiceMessageText']?.toString(),
      pictureMessageText: map['pictureMessageText']?.toString(),
      removeAdminText: map['removeAdminText']?.toString(),
      titleText: map['titleText']?.toString(),
      immediatelyReconnectionText: map['immediatelyReconnectionText']?.toString(),
      connectingText: map['connectingText']?.toString(),
      cleardialogueTipText: map['cleardialogueTipText']?.toString(),
      delOtherClearMessage: map['delOtherClearMessage']?.toString(),
      delAllClearMessage: map['delAllClearMessage']?.toString(),
      messageNotFind: map['messageNotFind']?.toString(),
      personText: map['personText']?.toString(),
      selectCountryText: map['selectCountryText']?.toString(),
      openText: map['openText']?.toString(),
      deleteMessageTipText: map['deleteMessageTipText']?.toString(),
      deleteOtherMessageTipText: map['deleteOtherMessageTipText']?.toString(),
      deleteAllMessageTipText: map['deleteAllMessageTipText']?.toString(),
      mediaText: map['mediaText']?.toString(),
      linkText: map['linkText']?.toString(),
      secondReconnectionText: map['secondReconnectionText']?.toString(),
      searchGroupMemberText: map['searchGroupMemberText']?.toString(),
      bannedConfirmTipText: map['bannedConfirmTipText']?.toString(),
      groupNameLimitToast: map['groupNameLimitToast']?.toString(),
      draftText: map['draftText']?.toString(),
      forbiddenTimeText: map['forbiddenTimeText']?.toString(),
      selectForbiddenTimeText: map['selectForbiddenTimeText']?.toString(),
      forbiddenText: map['forbiddenText']?.toString(),
      timeMinuteText: map['timeMinuteText']?.toString(),
      timeHourText: map['timeHourText']?.toString(),
      timeDayText: map['timeDayText']?.toString(),
      timePermanentText: map['timePermanentText']?.toString(),
      customText: map['customText']?.toString(),
      forbiddenToTimeText: map['forbiddenToTimeText']?.toString(),
      cancelForbiddenText: map['cancelForbiddenText']?.toString(),
      feedbackContentTipText: map['feedbackContentTipText']?.toString(),
      feedbackSupplementText: map['feedbackSupplementText']?.toString(),
      onloadPictureLengthText: map['onloadPictureLengthText']?.toString(),
      repliedText: map['repliedText']?.toString(),
      finishedText: map['finishedText']?.toString(),
      feedbackDetailText: map['feedbackDetailText']?.toString(),
      registerText: map['registerText']?.toString(),
      accountTipText: map['accountTipText']?.toString(),
      passwordTipText: map['passwordTipText']?.toString(),
      accountValidatorTipText: map['accountValidatorTipText']?.toString(),
      passwordValidatorTipText: map['passwordValidatorTipText']?.toString(),
      accountValidatorNumTipText: map['accountValidatorNumTipText']?.toString(),
      passwordValidatorNumTipText: map['passwordValidatorNumTipText']?.toString(),
      comfirmPasswordText: map['comfirmPasswordText']?.toString(),
      comfirmPasswordValidatorText: map['comfirmPasswordValidatorText']?.toString(),
      invitationText: map['invitationText']?.toString(),
      myReplayText: map['myReplayText']?.toString(),
      serviceText: map['serviceText']?.toString(),
      singleForbiddenText: map['singleForbiddenText']?.toString(),
      singleForbiddenYearText: map['singleForbiddenYearText']?.toString(),
      singleForbiddenMonthText: map['singleForbiddenMonthText']?.toString(),
      singleForbiddenDayText: map['singleForbiddenDayText']?.toString(),
      singleForbiddenHourText: map['singleForbiddenHourText']?.toString(),
      singleForbiddenMinuteText: map['singleForbiddenMinuteText']?.toString(),
      singleForbiddenSecondText: map['singleForbiddenSecondText']?.toString(),
      addFriendNotice: map['addFriendNotice']?.toString(),
      addFriendNoticeText: map['addFriendNoticeText']?.toString(),
      serverErrorText: map['serverErrorText']?.toString(),
      networkErrorText: map['networkErrorText']?.toString(),
      reconnectText: map['reconnectText']?.toString(),
      underwayText: map['underwayText']?.toString(),
      removeMemberByGroupText: map['removeMemberByGroupText']?.toString(),
      enterFeedbackTitleTipText: map['enterFeedbackTitleTipText']?.toString(),
      enterFeedbackContentTipText: map['enterFeedbackContentTipText']?.toString(),
      setMemberTipText: map['setMemberTipText']?.toString(),
      setManganeseTipText: map['setManganeseTipText']?.toString(),
      videoCallPermission: map['videoCallPermission']?.toString(),
      videoStatusWaiting: map['videoStatusWaiting']?.toString(),
      videoStatusRequest: map['videoStatusRequest']?.toString(),
      videoStatusAgree: map['videoStatusAgree']?.toString(),
      videoStatusRefuse: map['videoStatusRefuse']?.toString(),
      videoStatusConnecting: map['videoStatusConnecting']?.toString(),
      videoStatusActive: map['videoStatusActive']?.toString(),
      videoStatusClose: map['videoStatusClose']?.toString(),
      videoStatusDisconnected: map['videoStatusDisconnected']?.toString(),
      videoStatusCancel: map['videoStatusCancel']?.toString(),
      videoStatusBusy: map['videoStatusBusy']?.toString(),
      videoStatusNotAnswered: map['videoStatusNotAnswered']?.toString(),
      videoStatusFailed: map['videoStatusFailed']?.toString(),
      downloadText: map['downloadText']?.toString(),
      asSaveGalleryText: map['asSaveGalleryText']?.toString(),
      copyImageText: map['copyImageText']?.toString(),
      imageGallerySaverText: map['imageGallerySaverText']?.toString(),
      downloadSuccessText: map['downloadSuccessText']?.toString(),
      openDirText: map['openDirText']?.toString(),
      notFindVideoOrAudioDevice: map['notFindVideoOrAudioDevice']?.toString(),
      notFindVideoDevice: map['notFindVideoDevice']?.toString(),
      notFindAudioDevice: map['notFindAudioDevice']?.toString(),
      videoStatusOther: map['videoStatusOther']?.toString(),
      deviceBusy: map['deviceBusy']?.toString(),
      repeatLoginText: map['repeatLoginText']?.toString(),
      accountCodeTipText: map['accountCodeTipText']?.toString(),
      skipText: map['skipText']?.toString(),
      onlineCV: map['onlineCV']?.toString(),
      nameText: map['nameText']?.toString(),
      advantage: map['advantage']?.toString(),
      jobExp: map['jobExp']?.toString(),
      jobExpLocation: map['jobExpLocation']?.toString(),
      workExperience: map['workExperience']?.toString(),
      JobRquirement: map['JobRquirement']?.toString(),
      studyExperience: map['studyExperience']?.toString(),
      schoolName: map['schoolName']?.toString(),
      majorName: map['majorName']?.toString(),
      richAdvantage: map['richAdvantage']?.toString(),
      advantagePlaced: map['advantagePlaced']?.toString(),
      companyNameText: map['companyNameText']?.toString(),
      fillInText: map['fillInText']?.toString(),
      profilePhoto: map['profilePhoto']?.toString(),
      profilePhotoText: map['profilePhotoText']?.toString(),
      firstNameText: map['firstNameText']?.toString(),
      lastNameText: map['lastNameText']?.toString(),
      birthdateText: map['birthdateText']?.toString(),
      jobTimeText: map['jobTimeText']?.toString(),
      workLife: map['workLife']?.toString(),
      ageText: map['ageText']?.toString(),
      jobSearchStatus: map['jobSearchStatus']?.toString(),
      desiredPosition: map['desiredPosition']?.toString(),
      desiredCity: map['desiredCity']?.toString(),
      desiredIndustry: map['desiredIndustry']?.toString(),
      desiredSalary: map['desiredSalary']?.toString(),
      sureText: map['sureText']?.toString(),
      graduatedSchool: map['graduatedSchool']?.toString(),
      graduatedSchoolText: map['graduatedSchoolText']?.toString(),
      academincQualifications: map['academincQualifications']?.toString(),
      specialty: map['specialty']?.toString(),
      jobDirectionText: map['jobDirectionText']?.toString(),
      lookNewJobTips: map['lookNewJobTips']?.toString(),
      desiredPositionText: map['desiredPositionText']?.toString(),
      desiredCityText: map['desiredCityText']?.toString(),
      desiredIndustryText: map['desiredIndustryText']?.toString(),
      desiredMonthlySalaryText: map['desiredMonthlySalaryText']?.toString(),
      findJobText: map['findJobText']?.toString(),
      comeWorkAnyTimeTips: map['comeWorkAnyTimeTips']?.toString(),
      jobDetailsText: map['jobDetailsText']?.toString(),
      sendJobText: map['sendJobText']?.toString(),
      jobSeekInfoText: map['jobSeekInfoText']?.toString(),
      manText: map['manText']?.toString(),
      womanText: map['womanText']?.toString(),
      timeParticipationWorkTips: map['timeParticipationWorkTips']?.toString(),
      nextStepText: map['nextStepText']?.toString(),
      specialtyText: map['specialtyText']?.toString(),
      academicQualificationsText: map['academicQualificationsText']?.toString(),
      collegeNameText: map['collegeNameText']?.toString(),
      jobForText: map['jobForText']?.toString(),
      jobExpectationsText: map['jobExpectationsText']?.toString(),
      educationalExperienceText: map['educationalExperienceText']?.toString(),
      searchJobHereTips: map['searchJobHereTips']?.toString(),
      searchJobTips: map['searchJobTips']?.toString(),
      searchJobText: map['searchJobText']?.toString(),
      recentWorkExp: map['recentWorkExp']?.toString(),
      companyName: map['companyName']?.toString(),
      workingTime: map['workingTime']?.toString(),
      entryTime: map['entryTime']?.toString(),
      jobTitle: map['jobTitle']?.toString(),
      present: map['present']?.toString(),
      discoverText: map['discoverText']?.toString(),
      companyTipText: map['companyTipText']?.toString(),
      prohibitSimulator: map['prohibitSimulator']?.toString(),
      eduTipText: map['eduTipText']?.toString(),
      positionTipText: map['positionTipText']?.toString(),
      moneyTipText: map['moneyTipText']?.toString(),
      accountOrPasswordError: map['accountOrPasswordError']?.toString(),
      setUp: map['setUp']?.toString(),
      versionText: map['versionText']?.toString(),
      password: map['password']?.toString(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'loginButtonLabel': loginButtonLabel,
      'contactText': contactText,
      'myGroupText': myGroupText,
      'changeLanguage': changeLanguage,
      'selectLanguages': selectLanguages,
      'okButtonLabel': okButtonLabel,
      'cancelButtonLabel': cancelButtonLabel,
      'messageText': messageText,
      'contactsText': contactsText,
      'seeMoreText': seeMoreText,
      'groupText': groupText,
      'chatRecordText': chatRecordText,
      'deleteConversationText': deleteConversationText,
      'deleteConversation': deleteConversation,
      'clearHistory': clearHistory,
      'clearHistoryText': clearHistoryText,
      'pageSearchMessage': pageSearchMessage,
      'pageSearchFriend': pageSearchFriend,
      'pageSearchGroup': pageSearchGroup,
      'searchText': searchText,
      'friend': friend,
      'newGroupText': newGroupText,
      'newEncryptedConversation': newEncryptedConversation,
      'newContactText': newContactText,
      'newSecretContactText': newSecretContactText,
      'newGroupContactText': newGroupContactText,
      'addMemberText': addMemberText,
      'onlineStatusText': onlineStatusText,
      'phoneText': phoneText,
      'clearChatRecordsText': clearChatRecordsText,
      'viewChatRecordsText': viewChatRecordsText,
      'toppingText': toppingText,
      'noticeText': noticeText,
      'sendMessageText': sendMessageText,
      'addContactText': addContactText,
      'editContactText': editContactText,
      'removeContactText': removeContactText,
      'stopContactText': stopContactText,
      'loginText': loginText,
      'loginPagePhoneText': loginPagePhoneText,
      'loginPageCodeText': loginPageCodeText,
      'loginPagePhoneInput': loginPagePhoneInput,
      'loginPageCodeNum': loginPageCodeNum,
      'nextButton': nextButton,
      'pageChatDate': pageChatDate,
      'pageChatTime': pageChatTime,
      'remarksText': remarksText,
      'newFriendText': newFriendText,
      'sendText': sendText,
      'inputMsgHintText': inputMsgHintText,
      'recordingStartButtonText': recordingStartButtonText,
      'recordingEndButtonText': recordingEndButtonText,
      'cancelRecording': cancelRecording,
      'feedbackText': feedbackText,
      'shareAppText': shareAppText,
      'versionUpdateText': versionUpdateText,
      'aboutUsText': aboutUsText,
      'languageText': languageText,
      'dataStorageText': dataStorageText,
      'privacyAndSecurityText': privacyAndSecurityText,
      'notificationAndSoundText': notificationAndSoundText,
      'favoriteText': favoriteText,
      'personalDataText': personalDataText,
      'headPortraitText': headPortraitText,
      'idText': idText,
      'nicknameText': nicknameText,
      'genderText': genderText,
      'privateChatText': privateChatText,
      'clickText': clickText,
      'dialogueInformText': dialogueInformText,
      'otherText': otherText,
      'applicationNotificationText': applicationNotificationText,
      'receivingPromptToneText': receivingPromptToneText,
      'vibrationText': vibrationText,
      'voicePromptText': voicePromptText,
      'backstageServiceText': backstageServiceText,
      'backstageServiceTipText': backstageServiceTipText,
      'backgroundNetworkConnectionText': backgroundNetworkConnectionText,
      'backgroundNetworkConnectionTipText': backgroundNetworkConnectionTipText,
      'briefIntroductionText': briefIntroductionText,
      'finallyOnLineIdleText': finallyOnLineIdleText,
      'invitationPermissionControlText': invitationPermissionControlText,
      'holderText': holderText,
      'personalInformationText': personalInformationText,
      'blacklistText': blacklistText,
      'shieldUserText': shieldUserText,
      'equipmentText': equipmentText,
      'loginEquipmentText': loginEquipmentText,
      'accountText': accountText,
      'accountRetentionPeriodText': accountRetentionPeriodText,
      'dataUsageText': dataUsageText,
      'storageUsageText': storageUsageText,
      'onOneIsAllowedText': onOneIsAllowedText,
      'fileStorageTimeText': fileStorageTimeText,
      'clearCacheText': clearCacheText,
      'clearingLocalDataText': clearingLocalDataText,
      'wifiText': wifiText,
      'wifiTipText': wifiTipText,
      'mobileDataText': mobileDataText,
      'automaticallyDownload': automaticallyDownload,
      'addFriendText': addFriendText,
      'inputGroupNameHint': inputGroupNameHint,
      'selectGroupAvatarToast': selectGroupAvatarToast,
      'inputGroupNameToast': inputGroupNameToast,
      'groupInfoNumberText': groupInfoNumberText,
      'screenshotsManagementText': screenshotsManagementText,
      'banScreenshotsText': banScreenshotsText,
      'screenShotTipText': screenShotTipText,
      'circleText': circleText,
      'saveText': saveText,
      'maleText': maleText,
      'female': female,
      'addText': addText,
      'circleTipText': circleTipText,
      'circleAddText': circleAddText,
      'circleEnterText': circleEnterText,
      'addMemberToast': addMemberToast,
      'memberIdentityFounder': memberIdentityFounder,
      'memberIdentityMember': memberIdentityMember,
      'exitText': exitText,
      'maskedUsersText': maskedUsersText,
      'pictureText': pictureText,
      'videoText': videoText,
      'videoTextCall': videoTextCall,
      'audioTextCall': audioTextCall,
      'fileText': fileText,
      'pictureMobileTipText': pictureMobileTipText,
      'videoMobileTipText': videoMobileTipText,
      'fileMobileTipText': fileMobileTipText,
      'unknownText': unknownText,
      'maskedUsersTipText': maskedUsersTipText,
      'presentDeviceText': presentDeviceText,
      'othersDeviceText': othersDeviceText,
      'scanQRCodeText': scanQRCodeText,
      'deviceQuitTipText': deviceQuitTipText,
      'deviceOtherQuitTipText': deviceOtherQuitTipText,
      'onlineText': onlineText,
      'updateSuccessText': updateSuccessText,
      'everyoneText': everyoneText,
      'myContactText': myContactText,
      'hideText': hideText,
      'lastLoginTimeText': lastLoginTimeText,
      'retainMonthText': retainMonthText,
      'fileStorageTimeMonthText': fileStorageTimeMonthText,
      'fileStorageThreeDaysText': fileStorageThreeDaysText,
      'fileStorageWeekendText': fileStorageWeekendText,
      'fileStorageForeverText': fileStorageForeverText,
      'userAgreementText': userAgreementText,
      'PrivacyAgreement': PrivacyAgreement,
      'loginPhoneTipText': loginPhoneTipText,
      'loginCodeTipText': loginCodeTipText,
      'getCodeTipText': getCodeTipText,
      'countdownText': countdownText,
      'codeErrorTipText': codeErrorTipText,
      'cancelShieldText': cancelShieldText,
      'shieldUserLengthText': shieldUserLengthText,
      'mediaTypeText': mediaTypeText,
      'allSilenceText': allSilenceText,
      'photographersText': photographersText,
      'forbidSendTxtText': forbidSendTxtText,
      'forbidSendIconText': forbidSendIconText,
      'forbidSendFileText': forbidSendFileText,
      'forbidSendVoiceText': forbidSendVoiceText,
      'notOnlineText': notOnlineText,
      'modifyPhotoText': modifyPhotoText,
      'addSuccessText': addSuccessText,
      'personalizedSignatureText': personalizedSignatureText,
      'clearedHistoryListText': clearedHistoryListText,
      'newFriendsText': newFriendsText,
      'agreementText': agreementText,
      'refuseText': refuseText,
      'hasAgreedText': hasAgreedText,
      'hasRefuseText': hasRefuseText,
      'addSuccessFriendText': addSuccessFriendText,
      'addAgreeFriendText': addAgreeFriendText,
      'addRefuseFriendText': addRefuseFriendText,
      'searchContactsText': searchContactsText,
      'editText': editText,
      'setGroupPictureText': setGroupPictureText,
      'groupIntroduceText': groupIntroduceText,
      'editGroupPhotoText': editGroupPhotoText,
      'inputGroupNameText': inputGroupNameText,
      'selGroupPicture': selGroupPicture,
      'informationText': informationText,
      'searchInputText': searchInputText,
      'managementGroupText': managementGroupText,
      'searchOnlineRecordText': searchOnlineRecordText,
      'clearOnlineRecordText': clearOnlineRecordText,
      'inviteLinkText': inviteLinkText,
      'inviteMemberText': inviteMemberText,
      'groupMemberText': groupMemberText,
      'editGroupInfoText': editGroupInfoText,
      'delExitGroupText': delExitGroupText,
      'setManganeseText': setManganeseText,
      'setMemberText': setMemberText,
      'groupInRemove': groupInRemove,
      'tipText': tipText,
      'cancelText': cancelText,
      'clearButtonLabel': clearButtonLabel,
      'groupManagementText': groupManagementText,
      'joinSetText': joinSetText,
      'memberLookMsgTip': memberLookMsgTip,
      'newMemberJoinNotTip': newMemberJoinNotTip,
      'memberInteractText': memberInteractText,
      'memberAndInvisible': memberAndInvisible,
      'forbidInGroupAddTip': forbidInGroupAddTip,
      'onlyManageAddMember': onlyManageAddMember,
      'msgLimitsText': msgLimitsText,
      'allowSendText': allowSendText,
      'allowSendPictureText': allowSendPictureText,
      'allowSendVoiceText': allowSendVoiceText,
      'allowSendFileText': allowSendFileText,
      'bannedSetText': bannedSetText,
      'allBannedText': allBannedText,
      'startTimeText': startTimeText,
      'endTimeText': endTimeText,
      'dissolveGroupText': dissolveGroupText,
      'dissolveButtonLabel': dissolveButtonLabel,
      'adverseDelSuccessTip': adverseDelSuccessTip,
      'versionTips': versionTips,
      'phoneSelPicture': phoneSelPicture,
      'loadingText': loadingText,
      'noMoreResultText': noMoreResultText,
      'exitGroupTip': exitGroupTip,
      'cancelMemberTip': cancelMemberTip,
      'clearMsgRecordIp': clearMsgRecordIp,
      'dissolveGroupTip': dissolveGroupTip,
      'feedbackTitleTip': feedbackTitleTip,
      'feedbackContentTip': feedbackContentTip,
      'feedbackTitleText': feedbackTitleText,
      'feedbackContentText': feedbackContentText,
      'nicknameTipText': nicknameTipText,
      'inpNicknameCorrectTipText': inpNicknameCorrectTipText,
      'mobileDataTipText': mobileDataTipText,
      'cacheClearTipText': cacheClearTipText,
      'cacheTipText': cacheTipText,
      'submitButtonLabel': submitButtonLabel,
      'notFilledText': notFilledText,
      'pageSearchHint': pageSearchHint,
      'enterCodeText': enterCodeText,
      'briefIntroductionTipText': briefIntroductionTipText,
      'shieldSuccessText': shieldSuccessText,
      'cancelSuccessText': cancelSuccessText,
      'delConfirmTipText': delConfirmTipText,
      'shieldConfirmTipText': shieldConfirmTipText,
      'searchCountText': searchCountText,
      'shareLinkTip': shareLinkTip,
      'editGroupInfoTip': editGroupInfoTip,
      'addGroupMemberTip': addGroupMemberTip,
      'removeGroupMemberTip': removeGroupMemberTip,
      'microphonePermissionTipText': microphonePermissionTipText,
      'msgClearTipText': msgClearTipText,
      'nowExperienceTipText': nowExperienceTipText,
      'reloadLoginTipText': reloadLoginTipText,
      'logAgainText': logAgainText,
      'myCreateGroupText': myCreateGroupText,
      'myManageGroupText': myManageGroupText,
      'myJoinGroupText': myJoinGroupText,
      'groupMemberCountText': groupMemberCountText,
      'groupIntroductionHint': groupIntroductionHint,
      'exitGroupMemberTip': exitGroupMemberTip,
      'noCircleTipText': noCircleTipText,
      'joinCircleTipText': joinCircleTipText,
      'myCircleText': myCircleText,
      'circleJoinNumberText': circleJoinNumberText,
      'backText': backText,
      'circleSwitchTipText': circleSwitchTipText,
      'voiceUnderTime': voiceUnderTime,
      'clearRecordsText': clearRecordsText,
      'msgNotDisturbText': msgNotDisturbText,
      'msgTurnOnText': msgTurnOnText,
      'pinnedConversationText': pinnedConversationText,
      'operateTipText': operateTipText,
      'cancelPinnedConversationText': cancelPinnedConversationText,
      'addCircleTipText': addCircleTipText,
      'groupPhotoText': groupPhotoText,
      'groupNameText': groupNameText,
      'groupIntroText': groupIntroText,
      'addNewCircleText': addNewCircleText,
      'privateManagementText': privateManagementText,
      'privateManagementTipText': privateManagementTipText,
      'twoWayRevokeText': twoWayRevokeText,
      'twoWayRevokeTipText': twoWayRevokeTipText,
      'moreSecureText': moreSecureText,
      'moreSecureTipText': moreSecureTipText,
      'clearChatRecordsTipText': clearChatRecordsTipText,
      'inviteText': inviteText,
      'enterGroupText': enterGroupText,
      'chatRecordsCountText': chatRecordsCountText,
      'voiceText': voiceText,
      'groupTypeText': groupTypeText,
      'groupLinkText': groupLinkText,
      'bannedMemberText': bannedMemberText,
      'publicText': publicText,
      'privateText': privateText,
      'bannedMemberLengthText': bannedMemberLengthText,
      'bannedMemberTipText': bannedMemberTipText,
      'removeText': removeText,
      'updateManageLimitsText': updateManageLimitsText,
      'updateGroupInfoText': updateGroupInfoText,
      'delGroupInfoText': delGroupInfoText,
      'memberInteractSetText': memberInteractSetText,
      'memberLimitsSetText': memberLimitsSetText,
      'bannedToPostSetText': bannedToPostSetText,
      'bannedUserSetText': bannedUserSetText,
      'addNewManageText': addNewManageText,
      'limitsTipText': limitsTipText,
      'manageTitleText': manageTitleText,
      'groupManageText': groupManageText,
      'groupTypeTipText': groupTypeTipText,
      'feedbackListText': feedbackListText,
      'newFeedBackLabel': newFeedBackLabel,
      'addMemberOrGroupText': addMemberOrGroupText,
      'searchContactsOrGroupText': searchContactsOrGroupText,
      'supplementText': supplementText,
      'statusText': statusText,
      'readText': readText,
      'unreadText': unreadText,
      'mySupplementText': mySupplementText,
      'copyTipText': copyTipText,
      'selectOneChatText': selectOneChatText,
      'transpondText': transpondText,
      'selectGroupText': selectGroupText,
      'createNewChatText': createNewChatText,
      'lateContactsText': lateContactsText,
      'atMostChatText': atMostChatText,
      'sendToText': sendToText,
      'addBannedMemberText': addBannedMemberText,
      'groupTypeSecretTipText': groupTypeSecretTipText,
      'alreadyMemberText': alreadyMemberText,
      'pleaseSelectText': pleaseSelectText,
      'addUserText': addUserText,
      'replicatedText': replicatedText,
      'sendFailText': sendFailText,
      'sendingText': sendingText,
      'memberAlreadyText': memberAlreadyText,
      'replyText': replyText,
      'copyText': copyText,
      'asSaveText': asSaveText,
      'asSaveDownloadText': asSaveDownloadText,
      'deleteText': deleteText,
      'voiceMessageText': voiceMessageText,
      'pictureMessageText': pictureMessageText,
      'removeAdminText': removeAdminText,
      'titleText': titleText,
      'immediatelyReconnectionText': immediatelyReconnectionText,
      'connectingText': connectingText,
      'cleardialogueTipText': cleardialogueTipText,
      'delOtherClearMessage': delOtherClearMessage,
      'delAllClearMessage': delAllClearMessage,
      'messageNotFind': messageNotFind,
      'personText': personText,
      'selectCountryText': selectCountryText,
      'openText': openText,
      'deleteMessageTipText': deleteMessageTipText,
      'deleteOtherMessageTipText': deleteOtherMessageTipText,
      'deleteAllMessageTipText': deleteAllMessageTipText,
      'mediaText': mediaText,
      'linkText': linkText,
      'secondReconnectionText': secondReconnectionText,
      'searchGroupMemberText': searchGroupMemberText,
      'bannedConfirmTipText': bannedConfirmTipText,
      'groupNameLimitToast': groupNameLimitToast,
      'draftText': draftText,
      'forbiddenTimeText': forbiddenTimeText,
      'selectForbiddenTimeText': selectForbiddenTimeText,
      'forbiddenText': forbiddenText,
      'timeMinuteText': timeMinuteText,
      'timeHourText': timeHourText,
      'timeDayText': timeDayText,
      'timePermanentText': timePermanentText,
      'customText': customText,
      'forbiddenToTimeText': forbiddenToTimeText,
      'cancelForbiddenText': cancelForbiddenText,
      'feedbackContentTipText': feedbackContentTipText,
      'feedbackSupplementText': feedbackSupplementText,
      'onloadPictureLengthText': onloadPictureLengthText,
      'repliedText': repliedText,
      'finishedText': finishedText,
      'feedbackDetailText': feedbackDetailText,
      'registerText': registerText,
      'accountTipText': accountTipText,
      'passwordTipText': passwordTipText,
      'accountValidatorTipText': accountValidatorTipText,
      'passwordValidatorTipText': passwordValidatorTipText,
      'accountValidatorNumTipText': accountValidatorNumTipText,
      'passwordValidatorNumTipText': passwordValidatorNumTipText,
      'comfirmPasswordText': comfirmPasswordText,
      'comfirmPasswordValidatorText': comfirmPasswordValidatorText,
      'invitationText': invitationText,
      'myReplayText': myReplayText,
      'serviceText': serviceText,
      'singleForbiddenText': singleForbiddenText,
      'singleForbiddenYearText': singleForbiddenYearText,
      'singleForbiddenMonthText': singleForbiddenMonthText,
      'singleForbiddenDayText': singleForbiddenDayText,
      'singleForbiddenHourText': singleForbiddenHourText,
      'singleForbiddenMinuteText': singleForbiddenMinuteText,
      'singleForbiddenSecondText': singleForbiddenSecondText,
      'addFriendNotice': addFriendNotice,
      'addFriendNoticeText': addFriendNoticeText,
      'serverErrorText': serverErrorText,
      'networkErrorText': networkErrorText,
      'reconnectText': reconnectText,
      'underwayText': underwayText,
      'removeMemberByGroupText': removeMemberByGroupText,
      'enterFeedbackTitleTipText': enterFeedbackTitleTipText,
      'enterFeedbackContentTipText': enterFeedbackContentTipText,
      'setMemberTipText': setMemberTipText,
      'setManganeseTipText': setManganeseTipText,
      'videoCallPermission': videoCallPermission,
      'videoStatusWaiting': videoStatusWaiting,
      'videoStatusRequest': videoStatusRequest,
      'videoStatusAgree': videoStatusAgree,
      'videoStatusRefuse': videoStatusRefuse,
      'videoStatusConnecting': videoStatusConnecting,
      'videoStatusActive': videoStatusActive,
      'videoStatusClose': videoStatusClose,
      'videoStatusDisconnected': videoStatusDisconnected,
      'videoStatusCancel': videoStatusCancel,
      'videoStatusBusy': videoStatusBusy,
      'videoStatusNotAnswered': videoStatusNotAnswered,
      'videoStatusFailed': videoStatusFailed,
      'downloadText': downloadText,
      'asSaveGalleryText': asSaveGalleryText,
      'copyImageText': copyImageText,
      'imageGallerySaverText': imageGallerySaverText,
      'downloadSuccessText': downloadSuccessText,
      'openDirText': openDirText,
      'notFindVideoOrAudioDevice': notFindVideoOrAudioDevice,
      'notFindVideoDevice': notFindVideoDevice,
      'notFindAudioDevice': notFindAudioDevice,
      'videoStatusOther': videoStatusOther,
      'deviceBusy': deviceBusy,
      'repeatLoginText': repeatLoginText,
      'accountCodeTipText': accountCodeTipText,
      'skipText': skipText,
      'onlineCV': onlineCV,
      'nameText': nameText,
      'advantage': advantage,
      'jobExp': jobExp,
      'jobExpLocation': jobExpLocation,
      'workExperience': workExperience,
      'JobRquirement': JobRquirement,
      'studyExperience': studyExperience,
      'schoolName': schoolName,
      'majorName': majorName,
      'richAdvantage': richAdvantage,
      'advantagePlaced': advantagePlaced,
      'companyNameText': companyNameText,
      'fillInText': fillInText,
      'profilePhoto': profilePhoto,
      'profilePhotoText': profilePhotoText,
      'firstNameText': firstNameText,
      'lastNameText': lastNameText,
      'birthdateText': birthdateText,
      'jobTimeText': jobTimeText,
      'workLife': workLife,
      'ageText': ageText,
      'jobSearchStatus': jobSearchStatus,
      'desiredPosition': desiredPosition,
      'desiredCity': desiredCity,
      'desiredIndustry': desiredIndustry,
      'desiredSalary': desiredSalary,
      'sureText': sureText,
      'graduatedSchool': graduatedSchool,
      'graduatedSchoolText': graduatedSchoolText,
      'academincQualifications': academincQualifications,
      'specialty': specialty,
      'jobDirectionText': jobDirectionText,
      'lookNewJobTips': lookNewJobTips,
      'desiredPositionText': desiredPositionText,
      'desiredCityText': desiredCityText,
      'desiredIndustryText': desiredIndustryText,
      'desiredMonthlySalaryText': desiredMonthlySalaryText,
      'findJobText': findJobText,
      'comeWorkAnyTimeTips': comeWorkAnyTimeTips,
      'jobDetailsText': jobDetailsText,
      'sendJobText': sendJobText,
      'jobSeekInfoText': jobSeekInfoText,
      'manText': manText,
      'womanText': womanText,
      'timeParticipationWorkTips': timeParticipationWorkTips,
      'nextStepText': nextStepText,
      'specialtyText': specialtyText,
      'academicQualificationsText': academicQualificationsText,
      'collegeNameText': collegeNameText,
      'jobForText': jobForText,
      'jobExpectationsText': jobExpectationsText,
      'educationalExperienceText': educationalExperienceText,
      'searchJobHereTips': searchJobHereTips,
      'searchJobTips': searchJobTips,
      'searchJobText': searchJobText,
      'recentWorkExp': recentWorkExp,
      'companyName': companyName,
      'workingTime': workingTime,
      'entryTime': entryTime,
      'jobTitle': jobTitle,
      'present': present,
      'discoverText': discoverText,
      'companyTipText': companyTipText,
      'prohibitSimulator': prohibitSimulator,
      'eduTipText': eduTipText,
      'positionTipText': positionTipText,
      'moneyTipText': moneyTipText,
      'accountOrPasswordError': accountOrPasswordError,
      'setUp': setUp,
      'versionText': versionText,
      'password': password,
    };
  }

}

class _AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {
  final BuildContext context;

  const _AppLocalizationsDelegate(this.context);

  @override
  bool isSupported(Locale locale) => kMaterialSupportedLanguages.contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) {
    return DefaultAssetBundle.of(context).loadString("assets/languages/${locale.languageCode}.json").then((value) {
      return Languages.fromMap(json.decode(value)["data"]);
    }, onError: (e) {
      return Languages();
    });
    // return rootBundle.loadString("assets/languages/${locale.languageCode}.json").then((value) {
    //   return Languages.fromMap(json.decode(value)["data"]);
    // }, onError: (e) {
    //   return Languages();
    // });
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;

  @override
  String toString() => 'Languages.delegate(zh)';
}

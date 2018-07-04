<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Century21HomePage.ascx.cs" Inherits="mojoPortal.Web.Century21HomePage.Century21HomePage" %>
<%@ Register Src="~/CustomEventCalendar/HomePageEventsDisplay.ascx" TagPrefix="portal" TagName="HomePageEventsDisplay" %>
<%@ Register Src="~/Century21_Kaltura/Kaltura_HomePage.ascx" TagPrefix="Century21" TagName="KalturaVideoPlayer" %>

<script src="ClientScript/jqmojo/jquery.nivo.slider.pack3-2.js" type="text/javascript"></script>
<style>
    /*.clearfix .pvs. phm {
        display: none;
    }*/
</style>

<%--<div id="fb-root"></div>--%>
<%--<script>(function (d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.5&appId=834853613277660";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>--%>

<%--<div id="fb-root"></div>--%>
<script>
    //    (function (d, s, id) {
    //    var js, fjs = d.getElementsByTagName(s)[0];
    //    if (d.getElementById(id)) return;
    //    js = d.createElement(s); js.id = id;
    //    js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.3";
    //    fjs.parentNode.insertBefore(js, fjs);

    //}(document, 'script', 'facebook-jssdk'));

    function addCssFiles(url) {
        var head = document.getElementsByTagName('head')[0];
        var link = document.createElement('link');
        link.rel = 'stylesheet';
        link.type = 'text/css';
        link.href = url;
        link.media = 'all';
        head.appendChild(link);
    }
    $(document).ready(function () {
        loadconfigdata();
        
        //addCssFiles('/Data/Sites/1/skins/Theme_C21/fbstyle.css');
        $("#pageTitleId").hide();
        //        $(window).scrollTop(0);
        $('#slider').nivoSlider();
        //$(".cbVideoIframe").colorbox({ iframe: true, innerWidth: 425, innerHeight: 344 });
        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
            var src = serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/embedIframeJs/uiconf_id/" + mediaPlayerId + "/partner_id/" + partnerId + "?iframeembed=true&playerId=divKaltura_play_Video&entry_id=0_5u6iyyxy&flashvars[autoPlay]=true";
            $("#infoVideo").attr("href", src);
            $("#infoVideo").click(function() {
            
                window.open($(this).attr('href'), "_blank");
                return false;
            });
        }
        else {
            getKatulraVideoURL();
            $(".cbVideoIframe").colorbox({ iframe: true, innerWidth: 600, innerHeight: 500 });
        }
    });
    var kalturaPlayer = null;
    var serviceUrl = null;
    var secret = null;
    var userId = null;
    var partnerId = null;
    var expiry = null;
    var mediaPlayerId = null;
    var playVideoPageURL = null;
    var filterPageSize = null;
    var flag = null;
    var element = null;
    var categoryId = null;
    var playHomePageVideosURL = null;
    var rootWebURL = null;
    var client = null;
    function loadconfigdata()
    {
        kalturaPlayer = '<%=ConfigurationManager.AppSettings["kalturaPlayer"].ToString() %>';
        serviceUrl = '<%=ConfigurationManager.AppSettings["KalturaServiceUrl"].ToString() %>';
        secret = '<%=ConfigurationManager.AppSettings["KalturaAdminSecret"].ToString() %>';
        userId = '<%=ConfigurationManager.AppSettings["KalturaUserID"].ToString() %>';
        partnerId = '<%=ConfigurationManager.AppSettings["KalturaPartnerID"].ToString() %>';
        expiry = '<%=ConfigurationManager.AppSettings["KalturaSessionExpiry"].ToString() %>';
        var type = KalturaSessionType.ADMIN;
        mediaPlayerId = '<%=ConfigurationManager.AppSettings["KalturaMediaPlayerIDforHomePage"].ToString() %>';
        playVideoPageURL = '<%=ConfigurationManager.AppSettings["KalturaPlayVideosPageURL"].ToString() %>';
        filterPageSize = '<%=ConfigurationManager.AppSettings["KalturaFilterPageSize"].ToString() %>';
        flag = 0;
        categoryId = '<%=ConfigurationManager.AppSettings["KalturaPublicChannelID"].ToString() %>';
        playHomePageVideosURL = '<%=ConfigurationManager.AppSettings["KalturaPlayHomePageVideosURL"].ToString() %>';
        rootWebURL = '<%= SiteUtils.GetNavigationSiteRoot() %>';
    }

    function getKatulraVideoURL()
    {
        
        var src = serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/embedIframeJs/uiconf_id/" + mediaPlayerId + "/partner_id/" + partnerId + "?iframeembed=true&playerId=divKaltura_play_Video&entry_id=0_5u6iyyxy&flashvars[autoPlay]=true";
        
        
            $("#infoVideo").attr("href", src);
        
        
    }
    window.onorientationchange = function () { window.location.reload(); };
</script>


<%--<portal:NivoSlider ID="NivoSlider1" runat="server" ImageFolder='~/Data/Sites/1/media/nivoimages' ImageWidth='100%' CssClass="nivocustomclass" Config="effect: 'fade'" />--%>
<%--="http://cdnapi.kaltura.com/p/1424291/sp/142429100/embedIframeJs/uiconf_id/28657531/partner_id/1424291?iframeembed=true&playerId=divKaltura_play_Video&entry_id=0_5u6iyyxy&flashvars[autoPlay]=true" >--%>
<div class="slider-wrapper theme-default">
  <div id="slider" class="nivoSlider">
    
    <a class="cbVideoIframe" id ="infoVideo" href="#" >
        
        <img src="Data/Sites/1/media/nivoimages/banner_image1.jpg" alt=""></a>
<a class="cbVideoIframe" id ="A1" href="http://www.theceshop.com/" >
    <img src="Data/Sites/1/media/nivoimages/banner_image2.jpg" alt="">
    </a>
      <img src="Data/Sites/1/media/nivoimages/banner_image3.jpg" alt="">
      <img src="Data/Sites/1/media/nivoimages/banner_image4.jpg" alt="">
  </div>
</div>

    <%--<div class="art-footer-back"></div>--%>
    <div class="homepagetablepadding" style="padding-top: 15px;">
    <div  class="divwh"  style="">
       <div class="watchheader">
            <div><%= Resources.Resource.Century21HomePageEventWatch %></div>
        </div>
       <div class="HomePagetrData" style="width:100%;">
                <div class="HomePageKalturaSection" style="width:100%;">
                    <div style="width:100%;">
                        <Century21:KalturaVideoPlayer runat="server" ID="C21KalturaPlayer" />
                    </div>
                </div>
                
        </div>
     </div>
    <div class="divse" >
       <div class="socialeventsTabs" >
            
                    <ul class="tabs-menu">
                        <li id="li1" class="current socicalfeed">
                            <div class="socialFeedDivTitle"><%= Resources.Resource.Century21HomePageEventNews %></div>
                        </li>
<%--                        <li id="li2" class="eventsfeed">
                            <div><%= Resources.Resource.Century21HomePageEventEvents %></div>
                        </li>--%>
                    </ul>
                    <div class="HoemPageEventsSocial" id="HMPgEvtScl">             
                    <div id="wrapper">
                        <div id="leftcolumn" >
                            <div class="activeFBTabImageIndicator" id="FBTabActiveIndication">
                                <%--<img class="" src="Data/Sites/1/skins/Theme_C21/images/tab_arrow.png" alt="" />--%>
                            </div>
                        </div>
<%--                        <div id="rightcolumn">
                            <div class="activeEvtsTabImageIndicator" id="eventsTabActiveIndication">
                                <img class="" src="Data/Sites/1/skins/Theme_C21/images/tab_arrow.png" alt="" />
                            </div>
                        </div>--%>
                    </div>
                    <div style="clear:both;"></div>
                    <div id="tabs-container" class="newseventscontent" style="width:100%; float:left; ">
                        <div class="tab" style="width:100%; ">
                            <div id="tab-1" class="tab-content" style="width:100%;">
                                <%--commented on 20180419--%>
                                <%--<div style="text-align: center;width:100%; ">
                                    <img style="margin-top: 10px;" src="Data/Sites/1/skins/Theme_C21/images/TheLearning_icon.png" alt="" />
                                </div>--%>
                                <%--commented on 20180419--%>

                                <div id="newsContent" class="" style="color: black; width:100%;margin-top: 2px; overflow-y: scroll!important;height:378px;">
                                    <%--<ul style="list-style-type: square; list-style-position: inside;">--%>
                                    <%--<ul id="" style="width:100%;">
                                        <li class="favorite" style="">&nbsp;&nbsp;&nbsp;&nbsp;Increasing its presence globally.
                                        </li>
                                        <li class="favorite">&nbsp;&nbsp;&nbsp;&nbsp;International operations through-
                                        </li>
                                        <li class="favorite">&nbsp;&nbsp;&nbsp;&nbsp;The system is actively increasing
                                        </li>
                                        <li class="favorite">&nbsp;&nbsp;&nbsp;&nbsp;The system is actively increasing
                                        </li>
                                        <li class="favorite">&nbsp;&nbsp;&nbsp;&nbsp;International operations success
                                        </li>
                                        <li class="favorite">&nbsp;&nbsp;&nbsp;&nbsp;National operations through-
                                        </li>
                                        <li class="favorite">&nbsp;&nbsp;&nbsp;&nbsp;International operations through-
                                        </li>
                                        <li class="favorite">&nbsp;&nbsp;&nbsp;&nbsp;International operations through-
                                        </li>
                                    </ul>--%>
                                    <portal:ModuleWrapper ID="mdl100" runat="server" ConfigureModuleID="100" />
                                </div>
                            </div>
                            <div id="tab-2" class="tab-content" style="width:100%; ">
                                <portal:HomePageEventsDisplay runat="server" ID="HomePageEventsDisplay" />
                            </div>
                        </div>
                    </div>

                    <script>
                        $(document).ready(function () {

                            //$(".tabs-menu li").click(function () {
                            //    var tab = $(this).children().children().attr("href");
                            //    $(".tab-content").not(tab).css("display", "none");
                            //    $(tab).fadeIn();
                            //    if (this.id == "li1") {
                            //        $("#eventsTabActiveIndication").css('display', 'none');
                            //        $("#FBTabActiveIndication").css('display', 'block');
                            //        $("#tab-1").css('display', 'block');
                            //        //$("#li1").css('background-color', '#eeb443');
                            //        //$("#li2").css('background-color', '#e1a838');
                            //    }
                            //    else if (this.id == "li2") {
                            //        //$("#li1").css('background-color', '#e1a838');
                            //        //$("#li2").css('background-color', '#eeb443');
                            //        $("#tab-2").css('display', 'block');
                            //        $("#FBTabActiveIndication").css('display', 'none');
                            //        $("#eventsTabActiveIndication").css('display', 'block');
                            //    }
                            //});
                        });
                    </script>
<%--                    <script>
                        //(function ($) {
                        //    $(window).load(function () {
                        //        $.mCustomScrollbar.defaults.scrollButtons.enable = true;
                        //        $(".divHomePageVideosWithNames").mCustomScrollbar({ theme: "dark" });
                        //        $(".eventscrollable").mCustomScrollbar({ theme: "dark" });
                        //    });
                        //})(jQuery);
                    </script>--%>
                </div>
                </div>
       </div>
       <div  class="divnh"  style="">
       <div class="newsheader">
            <div><%= Resources.Resource.Century21HomePageEventSocial %></div>
        </div>
            <div class="HomePageNewsFeed newseventscontent" style="width:100%;">

                    <%--<iframe id="fbContent" src="http://www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2FC21University&width=309&colorscheme=light&show_faces=true&stream=true&header=false&height=459&show_border=false&show_footer=false" scrolling="no" frameborder="0" style="border: none !important; background:#F0F0F0 !important; overflow-y: hidden; height: 459px; width: 332px; float: left;" allowtransparency="true"></iframe>--%>
<%--                    <div class="fb-page" data-href="https://www.facebook.com/C21University" data-width="340" data-height="450" data-small-header="true" data-adapt-container-width="true" data-hide-cover="true" data-show-facepile="false" data-show-posts="true">
                        <div class="fb-xfbml-parse-ignore">
                            <blockquote cite="https://www.facebook.com/C21University">
                                <a href="https://www.facebook.com/C21University">C21 University</a>
                            </blockquote>
                        </div>
                    </div>--%>

                <div class="fb-page" data-href="https://www.facebook.com/century21" data-width="340" data-height="450" data-small-header="true" data-adapt-container-width="true" data-hide-cover="true" data-show-facepile="false" data-show-posts="true">
                    <div class="fb-xfbml-parse-ignore">
                        <blockquote cite="https://www.facebook.com/century21">
                            <a href="https://www.facebook.com/century21">C21 University</a>
                        </blockquote>
                    </div>
                </div>
                </div>
<%--                
            <script>
                $(window).load(function () {

                    $(window).scrollTop(0);

                });
            </script>--%>      
        </div>
                
    </div>

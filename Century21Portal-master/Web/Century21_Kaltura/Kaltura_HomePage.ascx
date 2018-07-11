<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Kaltura_HomePage.ascx.cs" Inherits="mojoPortal.Web.Century21_Kaltura.Kaltura_HomePage" %>


<style>
    /*iframe {
    display: none;
}*/

#loading {
    /*width: 300px;
    padding: 20px;
    background: orange;
    color: white;*/
    text-align: center;
    margin: 0 auto;
    display: none;
}
.truncateText {

    white-space: nowrap;
    text-overflow: ellipsis;
    display: block;

}

</style>
<script type="text/javascript">
    var onKalturaSessionEndSuccess = function (success, results) {
        if (!success)
            alert(results);
    };

    var onGetKalturaSessionSuccess = function (success, results) {
        if (!success)
            alert(results);

        if (results.code && results.message) {
            alert(results.message);
            return;
        }
        handleSession(results);
    };

    var onGetMediaInfoSuccess = function (success, results) {
        if (!success)
            alert(results);

        if (results.code && results.message) {
            alert(results.message);
            return;
        }
        handleMediaInfo(results);
    };

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

    //Read and initialize kaltura settings from web.config
    function initialize_DisplayVideosByCategory() {
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

        //Get kaltura session
        var config = new KalturaConfiguration(parseInt(partnerId));
        config.serviceUrl = '<%=ConfigurationManager.AppSettings["KalturaConfigServiceURL"].ToString() %>';
        client = new KalturaClient(config);
        var privileges = null;
        if (categoryId != null) {
            var kSessionStart = client.session.start(onGetKalturaSessionSuccess, secret, userId, type, parseInt(partnerId), parseInt(expiry), privileges);
        }
    }

    function handleSession(results) {
        client.setKs(results);
        var filter = new KalturaMediaEntryFilter();
        //filter.orderBy = "-recent";
        filter.orderBy = "-plays";
        filter.advancedSearch = new KalturaCategoryEntryAdvancedFilter();
        filter.categoriesIdsMatchAnd = String(categoryId);
        filter.mediaTypeEqual = KalturaMediaType.VIDEO;
        filter.statusIn = String(2);
        var pager = new KalturaFilterPager();
        pager.pageSize = 10;
        var result = client.media.listAction(onGetMediaInfoSuccess, filter, pager);
    }

    function handleMediaInfo(result) {
        for (var i = 0; i < result.objects.length; i++) {
            if (flag == 0) {
                var src = serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/embedIframeJs/uiconf_id/" + mediaPlayerId + "/partner_id/" + partnerId + "?iframeembed=true&width=315&playerId=divKaltura_play_Video&entry_id=" + result.objects[i].id;
                //$('#loading').show();
               // $('#loading').css('display', 'block');
                element = document.getElementById("myvideo");
                element.src = src;
              //  $(".comp").css("width", "255px");
                //$("#videoName").text(result.objects[i].name)
                flag++;
            }
            else if (flag > 0) {
                var description = result.objects[i].description != undefined && result.objects[i].description != null && result.objects[i].description != "" ? result.objects[i].description : "No Description Found for this Video.";
                var timeDuration = msToTime(result.objects[i].msDuration);
                element = document.getElementById("kaltura_media_subtable");
                element.innerHTML += "<tr><td class='tdHomePageVideoSubThumbnails'><a onclick=\"document.getElementById('myvideo').src='" + serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/embedIframeJs/uiconf_id/" + mediaPlayerId + "/partner_id/" + partnerId + "?iframeembed=true&playerId=divKaltura_play_Video&entry_id=" + result.objects[i].id + "'\" href='javascript:void(0);'><img alt='" + result.objects[i].name + "' src='" + result.objects[i].thumbnailUrl + "/width/120/'/><span class='video-time' aria-hidden='true'>" + timeDuration + "</span></a></td>" + "<td class='tdHomePageVideos'><a onclick=\"document.getElementById('myvideo').src='" + serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/embedIframeJs/uiconf_id/" + mediaPlayerId + "/partner_id/" + partnerId + "?iframeembed=true&playerId=divKaltura_play_Video&entry_id=" + result.objects[i].id + "'\" href='javascript:void(0)'>" + result.objects[i].name + "</a><div class='vedioDescription'>" + description + "</div></td></tr>";
                flag++;
            }

        }
    }
    //comp titleLabel pull-left truncateText

    function msToTime(duration) {
        if (duration > 0) {
            var milliseconds = parseInt((duration % 1000) / 100)
                , seconds = parseInt((duration / 1000) % 60)
                , minutes = parseInt((duration / (1000 * 60)) % 60)
                , hours = parseInt((duration / (1000 * 60 * 60)) % 24);

            hours = (hours < 10) ? "0" + hours : hours;
            minutes = (minutes < 10) ? "0" + minutes : minutes;
            seconds = (seconds < 10) ? "0" + seconds : seconds;

            if (hours == 0) {
                return minutes + ":" + seconds;
            }
            else {
                return hours + ":" + minutes + ":" + seconds;
            }
        }
        return "00:00";
    }

    $(document).ready(function () {
        initialize_DisplayVideosByCategory();

        var iFrame = $('#myvideo');
        iFrame.bind('load', function () { //binds the event
            $('#loading').css('display', 'none');
            $('#myvideo').css('display', 'block');
            
            //$('#myvideo').show();
        });
        //$(".comp.titleLabel.pull-left.truncateText").css("width", "255px!important");
        $(".truncateText").css({ 'width': 'auto' });
    });

    window.onload = setTimeout(function () {
        var kSessionEnd = client.session.end(onKalturaSessionEndSuccess);
    }, 25000);


</script>

<div class="divVideos">
    
    <div id='loading'><img src="Data/Sites/1/skins/Theme_C21/images/loading.gif" alt="Page is loading..." height="64" width="64"></div>
    <div class="divHomePageVideos" id="divKaltura_play_Video">
        <iframe id="myvideo" src="#" frameborder="0" style="position: relative; height: 100%; width: 100%; display:inline-table;"></iframe>
       <%-- <a id="videoName" href="#"></a>--%>
    </div>
    
    <br />
    <div class="divHomePageVideosWithNames">
        <table class="fullWidth">
            <tbody id="kaltura_media_subtable"></tbody>
        </table>
    </div>
    <br />
    <div class="kalturaMoreVideos"> <a href="/how-to-videos" >More Videos >> </a> </div>
</div>

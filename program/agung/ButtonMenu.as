class AniButton extends MovieClip
{
    var stop, _currentframe, onEnterFrame, nextFrame, prevFrame;
    function AniButton()
    {
        super();
        this.stop();
    } // End of the function
    function mcPlay(mc, fr)
    {
        fr == 0 || fr > mc._totalframes ? (fr = mc._totalframes) : (fr < 0 ? (fr = 1) : (null));
        mc.stop();
        mc.onEnterFrame = function ()
        {
            var _loc2 = _currentframe;
            if (_loc2 == fr)
            {
                delete this.onEnterFrame;
            }
            else
            {
                _loc2 > fr ? (this.prevFrame()) : (this.nextFrame());
            } // end else if
        };
    } // End of the function
    function onRollOver()
    {
        this.mcPlay(this, 0);
    } // End of the function
    function onRollOut()
    {
        this.mcPlay(this, 1);
    } // End of the function
    function onReleaseOutside()
    {
        this.mcPlay(this, 1);
    } // End of the function
} // End of Class

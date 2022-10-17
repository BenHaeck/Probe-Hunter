audioHelpers = {
};
function audioHelpers.playAudio (sound)
	if sound:isPlaying() then
		sound:seek(0);
	else
		love.audio.play(sound);
	end
end
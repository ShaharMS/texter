package texter.openfl._internal;

import lime.text.UTF8String;
import openfl.text.TextField;
import openfl.text.TextFormatAlign;
import openfl.text._internal.TextFormatRange;
import openfl.text._internal.TextEngine;
import openfl.text._internal.TextEngine.*;
import openfl.text._internal.TextLayoutGroup;
import openfl.text._internal.TextLayout;
import openfl.text._internal.GlyphPosition;
import openfl.utils._internal.Log;

class TextEngineRTL extends TextEngine {

	/**
	  decides if text should be interpreted as RTL text
	**/
	public var rtl:Bool;
    /**
        what scrpit to use when interpreting the language
    **/
    public var script:TextScript = null;
	/**
        the language the engine should use
	**/
	public var language:String = null;

	override private function getLayoutGroups():Void
	{
		layoutGroups.length = 0;

		if (text == null || text == "")
			return;

		var rangeIndex = -1;
		var formatRange:TextFormatRange = null;
		var font = null;

		var currentFormat = @:privateAccess TextField.__defaultTextFormat.clone();

		// line metrics
		var leading = 0; // the leading of the 0th character in a line is what's used for the whole line
		var ascent = 0.0, maxAscent = 0.0;
		var descent = 0.0;

		// paragraph metrics
		var align:TextFormatAlign = LEFT; // the metrics of the 0th character in a paragraph are used for the whole paragraph
		var blockIndent = 0;
		var bullet = false;
		var indent = 0;
		var leftMargin = 0;
		var rightMargin = 0;
		var firstLineOfParagraph = true;

		var tabStops = null; // TODO: maybe there's a better init value (not sure what this actually is)

		var layoutGroup:TextLayoutGroup = null, positions = null;
		var widthValue = 0.0, heightValue = 0, maxHeightValue = 0;
		var previousSpaceIndex = -2; // -1 equals not found, -2 saves extra comparison in `breakIndex == previousSpaceIndex`
		var previousBreakIndex = -1;
		var spaceIndex = text.indexOf(" ");
		var breakCount = 0;
		var breakIndex = breakCount < lineBreaks.length ? lineBreaks[breakCount] : -1;

		var offsetX = 0.0;
		var offsetY = 0.0;
		var textIndex = 0;
		var lineIndex = 0;

		#if !js
		inline
		#end
		function getPositions(text:UTF8String, startIndex:Int, endIndex:Int):Array<#if (js && html5) Float #else GlyphPosition #end>
		{
			// TODO: optimize

			var letterSpacing = 0.0;

			if (formatRange.format.letterSpacing != null)
			{
				letterSpacing = formatRange.format.letterSpacing;
			}

			#if (js && html5)
			function html5Positions():Array<Float>
			{
				var positions = [];

				if (__useIntAdvances == null)
				{
					__useIntAdvances = ~/Trident\/7.0/.match(Browser.navigator.userAgent); // IE
				}

				if (__useIntAdvances)
				{
					// slower, but more accurate if browser returns Int measurements

					var previousWidth = 0.0;
					var width;

					for (i in startIndex...endIndex)
					{
						width = __context.measureText(text.substring(startIndex, i + 1)).width;
						// if (i > 0) width += letterSpacing;

						positions.push(width - previousWidth);

						previousWidth = width;
					}
				}
				else
				{
					for (i in startIndex...endIndex)
					{
						var advance;

						if (i < text.length - 1)
						{
							// Advance can be less for certain letter combinations, e.g. 'Yo' vs. 'Do'
							var nextWidth = __context.measureText(text.charAt(i + 1)).width;
							var twoWidths = __context.measureText(text.substr(i, 2)).width;
							advance = twoWidths - nextWidth;
						}
						else
						{
							advance = __context.measureText(text.charAt(i)).width;
						}

						// if (i > 0) advance += letterSpacing;

						positions.push(advance);
					}
				}

				return positions;
			}
			return __shapeCache.cache(formatRange, html5Positions, text.substring(startIndex, endIndex));
			#else
			if (__textLayout == null)
			{
				__textLayout = new TextLayout();
			}

			var width = 0.0;

			__textLayout.text = null;
			__textLayout.font = font;

			if (formatRange.format.size != null)
			{
				__textLayout.size = formatRange.format.size;
			}

			__textLayout.letterSpacing = letterSpacing;
			__textLayout.autoHint = (antiAliasType != ADVANCED || sharpness < 400);

			// __textLayout.direction = RIGHT_TO_LEFT;
			// __textLayout.script = ARABIC;

			__textLayout.text = text.substring(startIndex, endIndex);
			return __shapeCache.cache(formatRange, __textLayout);
			#end
		}

		#if !js inline #end function getPositionsWidth(positions:#if (js && html5) Array<Float> #else Array<GlyphPosition> #end):Float

		{
			var width = 0.0;

			for (position in positions)
			{
				#if (js && html5)
				width += position;
				#else
				width += position.advance.x;
				#end
			}

			return width;
		}

		#if !js inline #end function getTextWidth(text:String):Float

		{
			#if (js && html5)
			return __context.measureText(text).width;
			#else
			if (__textLayout == null)
			{
				__textLayout = new TextLayout();
			}

			var width = 0.0;

			__textLayout.text = null;
			__textLayout.font = font;

			if (formatRange.format.size != null)
			{
				__textLayout.size = formatRange.format.size;
			}

			// __textLayout.direction = RIGHT_TO_LEFT;
			// __textLayout.script = ARABIC;

			__textLayout.text = text;

			for (position in __textLayout.positions)
			{
				width += position.advance.x;
			}

			return width;
			#end
		}

		#if !js inline #end function getBaseX():Float

		{
			if (rtl)
			{
				return width - (GUTTER + rightMargin + blockIndent + (firstLineOfParagraph ? indent : 0));
			}
			return GUTTER + leftMargin + blockIndent + (firstLineOfParagraph ? indent : 0);
		}

		#if !js inline #end function getWrapWidth():Float
		{
			if (rtl)
			{
				return getBaseX() - leftMargin - GUTTER;
			}
			return width - GUTTER - rightMargin - getBaseX();
		}

		#if !js inline #end function nextLayoutGroup(startIndex, endIndex):Void

		{
			if (layoutGroup == null || layoutGroup.startIndex != layoutGroup.endIndex)
			{
				layoutGroup = new TextLayoutGroup(formatRange.format, startIndex, endIndex);
				layoutGroups.push(layoutGroup);
			}
			else
			{
				layoutGroup.format = formatRange.format;
				layoutGroup.startIndex = startIndex;
				layoutGroup.endIndex = endIndex;
			}
		}

		#if !js inline #end function setLineMetrics():Void

		{
			@:privateAccess {
				if (currentFormat.__ascent != null)
				{
					ascent = currentFormat.size * currentFormat.__ascent;
					descent = currentFormat.size * currentFormat.__descent;
				}
				else if (#if lime font != null && font.unitsPerEM != 0 #else false #end)
				{
					#if lime
					ascent = (font.ascender / font.unitsPerEM) * currentFormat.size;
					descent = Math.abs((font.descender / font.unitsPerEM) * currentFormat.size);
					#end
				}
				else
				{
					ascent = currentFormat.size;
					descent = currentFormat.size * 0.185;
				}
            }

			leading = currentFormat.leading;

			heightValue = Math.ceil(ascent + descent + leading);

			if (heightValue > maxHeightValue)
			{
				maxHeightValue = heightValue;
			}

			if (ascent > maxAscent)
			{
				maxAscent = ascent;
			}
		}

		#if !js inline #end function setParagraphMetrics():Void

		{
			firstLineOfParagraph = true;

			align = currentFormat.align != null ? currentFormat.align : LEFT;
			blockIndent = currentFormat.blockIndent != null ? currentFormat.blockIndent : 0;
			indent = currentFormat.indent != null ? currentFormat.indent : 0;
			leftMargin = currentFormat.leftMargin != null ? currentFormat.leftMargin : 0;
			rightMargin = currentFormat.rightMargin != null ? currentFormat.rightMargin : 0;

			if (currentFormat.bullet != null)
			{
				// TODO
			}

			if (currentFormat.tabStops != null)
			{
				// TODO, may not actually belong in paragraph metrics
			}
		}

		#if !js inline #end function nextFormatRange():Bool

		{
			if (rangeIndex < textFormatRanges.length - 1)
			{
				rangeIndex++;
				formatRange = textFormatRanges[rangeIndex];
				@:privateAccess currentFormat.__merge(formatRange.format);

				#if (js && html5)
				__context.font = getFont(currentFormat);
				#end

				font = getFontInstance(currentFormat);

				return true;
			}

			return false;
		}

		#if !js inline #end function setFormattedPositions(startIndex:Int, endIndex:Int)

		{
			// sets the positions of the text from start to end, including format changes if there are any
			if (startIndex >= endIndex)
			{
				positions = [];
				widthValue = 0;
			}
			else if (endIndex <= formatRange.end)
			{
				positions = getPositions(text, startIndex, endIndex);
				widthValue = getPositionsWidth(positions);
			}
			else
			{
				var tempIndex = startIndex;
				var tempRangeEnd = formatRange.end;
				var countRanges = 0;

				positions = [];
				widthValue = 0;

				while (true)
				{
					if (tempIndex != tempRangeEnd)
					{
						var tempPositions = getPositions(text, tempIndex, tempRangeEnd);
						positions = positions.concat(tempPositions);
					}

					if (tempRangeEnd != endIndex)
					{
						if (!nextFormatRange())
						{
							Log.warn("You found a bug in OpenFL's text code! Please save a copy of your project and contact Joshua Granick (@singmajesty) so we can fix this.");
							break;
						}

						tempIndex = tempRangeEnd;
						tempRangeEnd = endIndex < formatRange.end ? endIndex : formatRange.end;

						countRanges++;
					}
					else
					{
						widthValue = getPositionsWidth(positions);
						break;
					}
				}

				rangeIndex -= countRanges + 1;
				nextFormatRange(); // get back to the formatRange and font
			}
		}

		#if !js inline #end function placeFormattedText(endIndex:Int):Void

		{
			if (endIndex <= formatRange.end)
			{
				// don't worry about placing multiple formats if a space or break happens first

				positions = getPositions(text, textIndex, endIndex);
				widthValue = getPositionsWidth(positions);

				nextLayoutGroup(textIndex, endIndex);

				layoutGroup.positions = positions;
				if (!rtl)
				{
					layoutGroup.offsetX = offsetX + getBaseX();
				}
				else
				{
					layoutGroup.offsetX = getBaseX() - offsetX;
				}
				layoutGroup.ascent = ascent;
				layoutGroup.descent = descent;
				layoutGroup.leading = leading;
				layoutGroup.lineIndex = lineIndex;
				layoutGroup.offsetY = offsetY + GUTTER;
				layoutGroup.width = widthValue;
				layoutGroup.height = heightValue;

				if (rtl)
				{
					offsetX -= widthValue;
				}
				else
				{
					offsetX += widthValue;
				}

				if (endIndex == formatRange.end)
				{
					layoutGroup = null;
					nextFormatRange();
					setLineMetrics();
				}
			}
			else
			{
				// fill in all text from start to end, including any format changes

				while (true)
				{
					var tempRangeEnd = endIndex < formatRange.end ? endIndex : formatRange.end;

					if (textIndex != tempRangeEnd)
					{
						positions = getPositions(text, textIndex, tempRangeEnd);
						widthValue = getPositionsWidth(positions);

						nextLayoutGroup(textIndex, tempRangeEnd);

						layoutGroup.positions = positions;
						layoutGroup.offsetX = offsetX + getBaseX();
						layoutGroup.ascent = ascent;
						layoutGroup.descent = descent;
						layoutGroup.leading = leading;
						layoutGroup.lineIndex = lineIndex;
						layoutGroup.offsetY = offsetY + GUTTER;
						layoutGroup.width = widthValue;
						layoutGroup.height = heightValue;

						if (rtl)
						{
							layoutGroup.offsetX -= widthValue;
							offsetX -= widthValue;
						}
						else
						{
							offsetX += widthValue;
						}

						textIndex = tempRangeEnd;
					}

					if (tempRangeEnd == formatRange.end)
						layoutGroup = null;

					if (tempRangeEnd == endIndex)
						break;

					if (!nextFormatRange())
					{
						Log.warn("You found a bug in OpenFL's text code! Please save a copy of your project and contact Joshua Granick (@singmajesty) so we can fix this.");
						break;
					}

					setLineMetrics();
				}
			}

			textIndex = endIndex;
		}

		#if !js inline #end function alignBaseline():Void

		{
			// aligns the baselines of all characters in a single line

			setLineMetrics();

			var i = layoutGroups.length;

			while (--i > -1)
			{
				var lg = layoutGroups[i];

				if (lg.lineIndex < lineIndex)
					break;
				if (lg.lineIndex > lineIndex)
					continue;

				lg.ascent = maxAscent;
				lg.height = maxHeightValue;
			}

			offsetY += maxHeightValue;

			maxAscent = 0.0;
			maxHeightValue = 0;

			++lineIndex;
			offsetX = 0;

			firstLineOfParagraph = false; // TODO: need to thoroughly test this
		}

		#if !js inline #end function breakLongWords(endIndex:Int):Void

		{
			// breaks up words that are too long to fit in a single line

			var remainingPositions = positions;
			var i, bufferCount, placeIndex, positionWidth;
			var currentPosition;

			var tempWidth = getPositionsWidth(remainingPositions);

			while (remainingPositions.length > 0 && offsetX + tempWidth > getWrapWidth())
			{
				i = bufferCount = 0;
				positionWidth = 0.0;

				while (offsetX + positionWidth < getWrapWidth())
				{
					currentPosition = remainingPositions[i];

					if (#if (js && html5) currentPosition #else currentPosition.advance.x #end == 0.0)
					{
						// skip Unicode character buffer positions
						i++;
						bufferCount++;
					}
					else
					{
						positionWidth += #if (js && html5) currentPosition #else currentPosition.advance.x #end;
						i++;
					}
				}

				// if there's no room to put even a single character, automatically wrap the next character
				if (i == bufferCount)
				{
					i = bufferCount + 1;
				}
				else
				{
					// remove characters until the text fits one line
					// because of combining letters potentially being broken up now, we have to redo the formatted positions each time
					// TODO: this may not work exactly with Unicode buffer characters...
					// TODO: maybe assume no combining letters, then compare result to i+1 and i-1 results?
					while (i > 1 && offsetX + positionWidth > getWrapWidth())
					{
						i--;

						if (i - bufferCount > 0)
						{
							setFormattedPositions(textIndex, textIndex + i - bufferCount);
							positionWidth = widthValue;
						}
						else
						{
							// TODO: does this run anymore?

							i = 1;
							bufferCount = 0;

							setFormattedPositions(textIndex, textIndex + 1);
							positionWidth = 0; // breaks out of the loops
						}
					}
				}

				placeIndex = textIndex + i - bufferCount;
				placeFormattedText(placeIndex);
				alignBaseline();

				setFormattedPositions(placeIndex, endIndex);

				remainingPositions = positions;
				tempWidth = widthValue;
			}

			// positions only contains the final unbroken line at the end
		}

		#if !js inline #end function placeText(endIndex:Int):Void

		{
			if (width >= GUTTER * 2 && wordWrap)
			{
				breakLongWords(endIndex);
			}

			placeFormattedText(endIndex);
		}

		nextFormatRange();
		setParagraphMetrics();
		setLineMetrics();

		var wrap;
		var maxLoops = text.length +
			1; // Do an extra iteration to ensure a LayoutGroup is created in case the last line is empty (multiline or trailing line break).
		// TODO: check if the +1 is still needed, since the extra layout group is handled separately

		while (textIndex < maxLoops)
		{
			if ((breakIndex > -1) && (spaceIndex == -1 || breakIndex < spaceIndex))
			{
				// if a line break is the next thing that needs to be dealt with
				// TODO: when is this condition ever false?
				if (textIndex <= breakIndex)
				{
					setFormattedPositions(textIndex, breakIndex);
					placeText(breakIndex);

					layoutGroup = null;
				}
				else if (layoutGroup != null && layoutGroup.startIndex != layoutGroup.endIndex)
				{
					// Trim the last space from the line width, for correct TextFormatAlign.RIGHT alignment
					if (layoutGroup.endIndex == spaceIndex)
					{
						layoutGroup.width -= layoutGroup.getAdvance(layoutGroup.positions.length - 1);
					}

					layoutGroup = null;
				}

				alignBaseline();

				// TODO: is this necessary or already handled by placeText above?
				if (formatRange.end == breakIndex)
				{
					nextFormatRange();
					setLineMetrics();
				}

				textIndex = breakIndex + 1;
				previousBreakIndex = breakIndex;
				breakCount++;
				breakIndex = breakCount < lineBreaks.length ? lineBreaks[breakCount] : -1;

				setParagraphMetrics();
			}
			else if (spaceIndex > -1)
			{
				// if a space is the next thing that needs to be dealt with

				if (layoutGroup != null && layoutGroup.startIndex != layoutGroup.endIndex)
				{
					layoutGroup = null;
				}

				wrap = false;

				while (true)
				{
					if (textIndex >= text.length)
						break;

					var endIndex = -1;

					if (spaceIndex == -1)
					{
						endIndex = breakIndex;
					}
					else
					{
						endIndex = spaceIndex + 1;

						if (breakIndex > -1 && breakIndex < endIndex)
						{
							endIndex = breakIndex;
						}
					}

					if (endIndex == -1)
					{
						endIndex = text.length;
					}

					setFormattedPositions(textIndex, endIndex);

					if (align == JUSTIFY)
					{
						if (positions.length > 0 && textIndex == previousSpaceIndex)
						{
							// Trim left space of this word
							textIndex++;

							var spaceWidth = #if (js && html5) positions.shift() #else positions.shift().advance.x #end;
							widthValue -= spaceWidth;
							offsetX += spaceWidth;
						}

						if (positions.length > 0 && endIndex == spaceIndex + 1)
						{
							// Trim right space of this word
							endIndex--;

							var spaceWidth = #if (js && html5) positions.pop() #else positions.pop().advance.x #end;
							widthValue -= spaceWidth;
						}
					}

					if (wordWrap)
					{
						if (offsetX + widthValue > getWrapWidth())
						{
							wrap = true;

							if (positions.length > 0 && endIndex == spaceIndex + 1)
							{
								// if last letter is a space, avoid word wrap if possible
								// TODO: Handle multiple spaces

								var lastPosition = positions[positions.length - 1];
								var spaceWidth = #if (js && html5) lastPosition #else lastPosition.advance.x #end;

								if (offsetX + widthValue - spaceWidth <= getWrapWidth())
								{
									wrap = false;
								}
							}
						}
					}

					if (wrap)
					{
						if (align != JUSTIFY && (layoutGroup != null || layoutGroups.length > 0))
						{
							var previous = layoutGroup;
							if (previous == null)
							{
								previous = layoutGroups[layoutGroups.length - 1];
							}

							// For correct selection rectangles and alignment, trim the trailing space of the previous line:
							previous.width -= previous.getAdvance(previous.positions.length - 1);
							previous.endIndex--;
						}

						var i = layoutGroups.length - 1;
						var offsetCount = 0;

						while (true)
						{
							layoutGroup = layoutGroups[i];

							if (i > 0 && layoutGroup.startIndex > previousSpaceIndex)
							{
								offsetCount++;
							}
							else
							{
								break;
							}

							i--;
						}

						if (textIndex == previousSpaceIndex + 1)
						{
							alignBaseline();
						}

						offsetX = 0;

						if (offsetCount > 0)
						{
							var bumpX = layoutGroups[layoutGroups.length - offsetCount].offsetX;

							for (i in (layoutGroups.length - offsetCount)...layoutGroups.length)
							{
								layoutGroup = layoutGroups[i];
								layoutGroup.offsetX -= bumpX;
								layoutGroup.offsetY = offsetY + GUTTER;
								layoutGroup.lineIndex = lineIndex;
								offsetX += layoutGroup.width;
							}
						}

						placeText(endIndex);

						wrap = false;
					}
					else
					{
						if (layoutGroup != null && textIndex == spaceIndex)
						{
							// TODO: does this case ever happen?
							if (align != JUSTIFY)
							{
								layoutGroup.endIndex = spaceIndex;
								layoutGroup.positions = layoutGroup.positions.concat(positions);
								layoutGroup.width += widthValue;
							}

							if (rtl)
							{
								offsetX -= widthValue;
							}
							else
							{
								offsetX += widthValue;
							}

							textIndex = endIndex;
						}
						else if (layoutGroup == null || align == JUSTIFY)
						{
							placeText(endIndex);
							if (endIndex == text.length)
								alignBaseline();
						}
						else
						{
							var tempRangeEnd = endIndex < formatRange.end ? endIndex : formatRange.end;

							if (tempRangeEnd < endIndex)
							{
								positions = getPositions(text, textIndex, tempRangeEnd);
								widthValue = getPositionsWidth(positions);
							}

							layoutGroup.endIndex = tempRangeEnd;
							if (rtl)
							{
								layoutGroup.positions = positions.concat(layoutGroup.positions);
							}
							else
							{
								layoutGroup.positions = layoutGroup.positions.concat(positions);
							}
                            layoutGroup.width += widthValue;

							if (rtl)
							{
								offsetX -= widthValue;
							}
							else
							{
								offsetX += widthValue;
							}

							if (tempRangeEnd == formatRange.end)
							{
								layoutGroup = null;
								nextFormatRange();
								setLineMetrics();

								textIndex = tempRangeEnd;

								if (tempRangeEnd != endIndex)
								{
									placeFormattedText(endIndex);
								}
							}

							// If next char is newline, process it immediately and prevent useless extra layout groups
							// TODO: is this needed?
							if (breakIndex == endIndex)
								endIndex++;

							textIndex = endIndex;

							if (endIndex == text.length)
								alignBaseline();
						}
					}

					var nextSpaceIndex = text.indexOf(" ", textIndex);

					// Check if we can continue wrapping this line until the next line-break or end-of-String.
					// When `previousSpaceIndex == breakIndex`, the loop has finished growing layoutGroup.endIndex until the end of this line.

					if (breakIndex == previousSpaceIndex)
					{
						layoutGroup.endIndex = breakIndex;

						if (breakIndex - layoutGroup.startIndex - layoutGroup.positions.length < 0)
						{
							// Newline has no size
							layoutGroup.positions.push(#if (js && html5) 0.0 #else null #end);
						}

						textIndex = breakIndex + 1;
					}

					previousSpaceIndex = spaceIndex;
					spaceIndex = nextSpaceIndex;

					if ((breakIndex > -1 && breakIndex <= textIndex && (spaceIndex > breakIndex || spaceIndex == -1))
						|| textIndex > text.length)
					{
						break;
					}
				}
			}
			else
			{
				if (textIndex < text.length)
				{
					// if there are no line breaks or spaces to deal with next, place all remaining text

					setFormattedPositions(textIndex, text.length);
					placeText(text.length);

					alignBaseline();
				}

				textIndex++;
			}
		}

		// if final char is a line break, create an empty layoutGroup for it
		if (previousBreakIndex == textIndex - 2 && previousBreakIndex > -1)
		{
			nextLayoutGroup(textIndex - 1, textIndex - 1);

			layoutGroup.positions = [];
			layoutGroup.ascent = ascent;
			layoutGroup.descent = descent;
			layoutGroup.leading = leading;
			layoutGroup.lineIndex = lineIndex;
			layoutGroup.offsetX = getBaseX(); // TODO: double check it doesn't default to GUTTER or something
			layoutGroup.offsetY = offsetY + GUTTER;
			layoutGroup.width = 0;
			layoutGroup.height = type == "input" ? heightValue : 0;
		}

		#if openfl_trace_text_layout_groups
		for (lg in layoutGroups)
		{
			Log.info('LG ${lg.positions.length - (lg.endIndex - lg.startIndex)},line:${lg.lineIndex},w:${lg.width},h:${lg.height},x:${Std.int(lg.offsetX)},y:${Std.int(lg.offsetY)},"${text.substring(lg.startIndex, lg.endIndex)}",${lg.startIndex},${lg.endIndex}');
		}
		#end
	}

	override public function restrictText(value:UTF8String):UTF8String
	{
		if (value == null)
		{
			return value;
		}

		if (__restrictRegexp != null)
		{
			value = __restrictRegexp.split(value).join("");
		}

		// if (maxChars > 0 && value.length > maxChars) {

		// 	value = value.substr (0, maxChars);

		// }

		return value;
	}
}
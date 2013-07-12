
var radD = 180 / Math.PI
var DegR = Math.PI / 180

var MathLib = (function() {
	//print('MathLib: Initializing...')
	var matLib_mt = {}

	matLib_mt.New = function(){
		var matLib = {}
			
		matLib.Destroy = function(){
			//print('MathLib:Destroy()')			
		}
		
		matLib.DegreeToRadian = function(angle){
            return Math.PI * angle / 180.0;
        }

        matLib.RadianToDegree = function(angle){
            return angle * (180.0 / Math.PI);
        }
		
		matLib.getVectorCoords = function(inAngle){
			var x = Math.cos(this.DegreeToRadian(inAngle))
			var y = Math.sin(this.DegreeToRadian(inAngle))
			return [x, y]
		}
			
		matLib.getAbsDistance = function(x1,y1,x2,y2){
			var xDist = x2 - x1
			var yDist = y2 - y1
			var dist = Math.abs(Math.sqrt(Math.pow(xDist,2)+Math.pow(yDist,2)))	
			return dist
		}

		matLib.getDistance = function(x1,y1,x2,y2){
			var xDist = x2 - x1
			var yDist = y2 - y1
			var dist = Math.sqrt(Math.pow(xDist,2)+Math.pow(yDist,2))
			return dist
		}

		matLib.getDistanceFromObjects = function(obj1, obj2){
			var xDist = obj1.x - obj2.x
			var yDist = obj1.y - obj2.y
			var dist = Math.sqrt((xDist * xDist) + (yDist * yDist))		
			return dist
		}

		matLib.getAbsDistanceFromObjects = function(obj1, obj2){
			var xDist = Math.abs(obj1.x - obj2.x)
			var yDist = Math.abs(obj1.y - obj2.y)
			var dist = Math.sqrt((xDist * xDist) + (yDist * yDist))		
			return dist
		}
		
		matLib.getNextDeg = function(inDegrees, inIncrement){
			var inc = inIncrement || 1
			var tmpDeg = inDegrees + inc
			if(Math.round(tmpDeg) > 360) {
				tmpDeg = 1
			}
			return tmpDeg
		}

		matLib.getOppositeDeg = function(inAngle){
			var tmpAngle = inAngle + 180
			//Do we really need to worry about keeping it positive, not so sure...
			if(tmpAngle > 360){
				tmpAngle = tmpAngle - 360
			}		
			return tmpAngle
		}

		matLib.getAngleDeg = function(xDist, yDist, asWindows){
			var tmpAngle = Math.atan2( yDist , xDist ) * radD
			if(asWindows == true){
				tmpAngle = tmpAngle - 90
			}
			if(tmpAngle < 0){ 
				tmpAngle = 360 + tmpAngle 
			}
			return tmpAngle
		}

		matLib.getAngleDegFromDistance = function (xDist, yDist){
			//Corona Velocity works in Windows coordinate system
			var tmpAngle = Math.atan2(yDist, xDist ) * (radD) + 90
			return tmpAngle
		}

		/*
		matLib.getAngleDegFromCoronaVelocity = function(obj1){
			var vx, vy = obj1:getLinearVelocity()
			//print(vx .. " : " .. vy)
			//Corona Velocity works in Windows coordinate system
			var tmpAngle = Math.Atan2(vy, vx ) * (radD) + 90
			return tmpAngle
		}
		*/
		
		matLib.getAngleRad = function(xDist, yDist){
			return Math.atan2(yDist, xDist)
		}

		matLib.getAngleRadFromObjects = function(obj1, obj2){
			var xDist = obj2.x - obj1.x
			var yDist = obj2.y - obj1.y
			return Math.atan2(yDist, xDist)
		}

		matLib.getAngleDegFromObjects = function(obj1, obj2, asWindows){
			var tmpAngle = getAngleRadFromObjects(obj1, obj2) * radD
			if(asWindows){
				tmpAngle = tmpAngle + 90
			}
			return tmpAngle
		}

		matLib.getOrbitalLocationFromObjectDeg = function(obj1, inDistance, inAngleDeg){
			var ox = obj1.left || obj1.x
			var oy = obj1.top || obj1.y
			var returnCoords = {}
			var radAngle = this.DegreeToRadian(inAngleDeg)
			
			returnCoords.x = ox + inDistance * Math.cos(radAngle)
			returnCoords.y = oy + inDistance * Math.sin(radAngle)			
			return returnCoords
		}

		matLib.getOrbitalLocationFromObjectRad = function(obj1, inDistance, inAngleRad){
			var ox = obj1.left || obj1.x
			var oy = obj1.top || obj1.y
			var returnCoords = {}
			
			returnCoords.x = ox + inDistance * Math.cos(inAngleRad)
			returnCoords.y = oy + inDistance * Math.sin(inAngleRad)			
			return returnCoords
		}
		
		matLib.isInCircle = function(cX, cY, r, x, y){
			var dist = Math.Pow(cX - x, 2) + Math.Pow(cY - y, 2)
			return dist <= r*r
		}

		matLib.isInSquare = function(cX, cY, width, x, y){
			var bResult = false
			if(x >= cX - (width *.5)){
				if(x <= cX + (width *.5)){
					if(y >= cY - (width *.5)){
						if(y <= cY + (width *.5)){
							bResult = true
						}
					}
				}
			}
			return bResult
		}

		matLib.getPercent = function(inNum, inAmount){
			var percent = (inNum / inAmount) * 100
			return percent
		}

		matLib.getDecPercent = function(inNum, inAmount){
			var percent = inNum / inAmount
			return percent
		}

		matLib.getAmount = function(inNum, inPercentOf){
			var amount = (inNum * inPercentOf) / 100
			return amount
		}

		matLib.VectorFromObjects = function(inObj1, inObj2){
			var vx = inObj1.x - inObj2.x
			var vy = inObj1.y - inObj2.y
			return [vx,vy]
		}

		//Possible random number stuff
		/*
		matLib.ShuffleTable = function(inTable)
			var j
			var r = math.random
			for i = #t, 2, -1 do
				j = r(i)
				t[i], t[j] = t[j], t[i]
			end
			return t
		end
		*/
		
		return matLib
	}
	return matLib_mt
}())
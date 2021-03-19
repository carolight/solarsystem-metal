//
/**
 * Copyright (c) 2019 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import Foundation

protocol RocketController: class {
  var forwardVector: float3  { get set }
  var rightVector: float3  { get set }
  var upVector: float3  { get set }

  var currentThrust: Float { get set }
  var rotationSpeed: Float { get set }
  var maximumThrust: Float { get set }

  var position: float3 { get set }
}

extension RocketController {
  func updatePlayer(deltaTime: Float, keys: Set<KeyboardControl>) {
    let translationSpeed = deltaTime * self.currentThrust
    let rotationSpeed = deltaTime * self.rotationSpeed
    for key in keys {
      switch key {
      case .space:
        currentThrust = maximumThrust
      case .w, .s:
        // pitch - rotation on x axis
        let speed = key == .w ? rotationSpeed : -rotationSpeed
        let pitch = simd_quatf(angle: speed, axis: rightVector)
        forwardVector = pitch.act(forwardVector)
        forwardVector = normalize(forwardVector)
        upVector = cross(forwardVector, rightVector)
      case .a, .d:
        // yaw - rotation on y axis
        let speed = key == .a ? rotationSpeed : -rotationSpeed
        let yaw = simd_quatf(angle: speed, axis: upVector)
        rightVector = yaw.act(rightVector)
        rightVector = normalize(rightVector)
        forwardVector = cross(rightVector, upVector)
      case .q, .e:
        // roll - rotation on z axis
        let speed = key == .q ? rotationSpeed : -rotationSpeed
        let roll = simd_quatf(angle: speed,
                              axis: forwardVector)
        upVector = roll.act(upVector)
        upVector = normalize(upVector)
        rightVector = cross(upVector, forwardVector)
      default:
        break
      }
      print(length(forwardVector), length(upVector), length(rightVector))
      position += translationSpeed * forwardVector
    }
  }
}

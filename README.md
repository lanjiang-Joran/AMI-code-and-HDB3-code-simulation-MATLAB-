# AMI code and HDB3 code simulation (MATLAB)
In digital baseband transmission, the transmission code type selection has the following principles:
1.Does not contain DC, and the low frequency component is as little as possible;
2. It should contain rich timing information to facilitate the extraction of timing signals from the received stream;
3. The width of the main lobe of the power spectrum is narrow to save the transmission frequency band;
4.  Not affected by the statistical characteristics of the information source, that is, can adapt to the change of the information source;
5. Has the inherent error detection ability, that is, the code pattern has a certain regularity, in order to use this regularity for macro monitoring;
6. Simple coding and decoding to reduce communication delay and cost.

This article will introduce AMI code and HDB3 code and provide corresponding MATLAB simulation code.



# 1.AMI
AMI  code is the full name of alternate mark inversion code, its encoding rule is to alternately transform the message code "1" (mark) to "+1" and "-1", while the "0" (empty sign) remains unchanged. For example:
|information|0|1|1|0|0|0|0|0|0|0|1|1|0|0|1|1|
|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
|**AMI code**|0|-1|+1|0|0|0|0|0|0|0|-1|+1|0|0|-1|+1|

Advantages: there is no DC component, and the high and low frequency components are less, and the energy is concentrated at the frequency of 1/2 yard speed; The codec circuit is simple, and the code error can be observed by using the law of mark alternations. If it is an AMI-RZ waveform, after receiving it, as long as the full wave rectification, it can be changed into a unipolar RZ waveform, from which the bit timing component can be extracted. In view of the above advantages, AMI code has become one of the most commonly used transmission codes.

Disadvantages: When the original code appears a long "0" string, the level of the signal does not jump for a long time, resulting in difficulty in extracting the timing signal. One of the effective ways to solve the problem of "0" code is to use HDB3 code.




# 2.HDB3
The full name of HDB3 code is third-order high-density bipolar code. It is an improved version of AMI code, the purpose of improvement is to maintain the advantages of AMI and overcome its disadvantages, so that the number of "0" does not exceed three. Its encoding rules are as follows:
1. First check the number of connected "0" of the message code, when the number of connected "0" is less than or equal to 3, the coding rule is the same as that of the AMI code.
2. When the number of consecutive "0" exceeds 3, every 4 consecutive "0" is turned into a subsection and replaced with "000V". V (taking the value +1 or -1) should have the same polarity as the previous adjacent non-" 0 "pulse (because this breaks the polarity alternation principle, V is called the destruction pulse).
3. Adjacent V-code polarities must alternate. When the V code can meet the requirements in (2) but cannot meet this requirement, "0000" is replaced by "B00V". The value of B is the same as the V pulse, which is used to solve this problem, so B is called the regulating pulse.
4.  The polarity of the number transmission after the V code should also be alternating. For example:

 |information|1|0|0|0|0|1|0|0|0|0|1|1|0|0|0|0|0|0|0|0|1|1|
|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
|**AMI code**|-1|0|0|0|0|+1|0|0|0|0|-1|+1|0|0|0|0|0|0|0|0|-1|+1|
|**HDB3 code**|-1|0|0|0|-V|+1|0|0|0|+V|-1|+1|-B|0|0|-V|+B|0|0|-V|-1|+1|

The pulses of V and B are the same as those of +1 and -1.
In addition to the advantages of AMI, HDB3 code also limits the number of even "0" codes to within 3, so that the timing information can be extracted when receiving. Therefore, HDB3 code is the most widely used code type in Europe and other countries, and the interface code type below the fourth group of A law PCM is HDB3 code.


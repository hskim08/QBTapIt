#!/usr/bin/env python
"""
Process midi files and translate them into text files suitable for
import into MATLAB, NumPy or others.

@author: Jorge Herrera
"""

import os
import sys
import warnings
import midi

# main parameters
USE_TIME_IN_SECONDS = True  # if True, output events will be in seconds (not ticks)

# IMPORTANT: this defines the hope size of the output
DELTA_MS = 20  # hop size of the output, in ms
DELTA_SEC = DELTA_MS / 1000.0

# Here's where the txt files will be saved
OUTPUT_DIR = 'output/'


class Params:
    """
    Helper class to contain the 'global' parameters of a midi file
    """
    def __init__(self):
        self.name = ""
        self.bpm = 120
        self.time_signature = {'numerator': 4,
                               'denominator': 4,
                               'metro': 24,
                               '32nds': 8}
                               # For more details, see the 'Time Signature'
                               # section at
                               # http://www.sonicspot.com/guide/midifiles.html


def processType0(midifile):
    """
    Process midi file of format 0: a single track with all the events, including
    song title, time signature, tempo and music events.
    """
    # TODO: implement
    # warnings.warn("Processing of midi files of format 0 is not yet implemented")
    params = Params()
    on_events = []
    off_events = []
    midi_keys = set([])

    for track_idx, track in enumerate(midifile):
        cum_tick = 0
        for event in track:
            if isinstance(event, midi.events.TrackNameEvent):
                params.name = "".join(map(chr, event.data))
            elif isinstance(event, midi.events.SetTempoEvent):
                params.bpm = event.bpm
            elif isinstance(event, midi.events.TimeSignatureEvent):
                params.time_signature['numerator'] = event.numerator
                params.time_signature['denominator'] = event.denominator
                params.time_signature['metro'] = event.metronome
                params.time_signature['32nds'] = event.thirtyseconds
            elif isinstance(event, midi.events.EndOfTrackEvent):
                pass
            elif isinstance(event, midi.events.NoteOnEvent):
                # print repr(event.tick) + ":\t" + repr(event.data[0]) + "\t" + repr(event.data[1])
                cum_tick = cum_tick + event.tick
                # (time, midi_note, velocity)
                e = [cum_tick, event.data[0], event.data[1]]
                if not event.data[1] == 0:
                    on_events.append(e)
                    midi_keys.add(event.data[0])
                else:
                    off_events.append(e)
            elif isinstance(event, midi.events.NoteOffEvent):
                # print repr(event.tick) + ":\t" + repr(event.data[0]) + "\t" + repr(event.data[1])
                cum_tick = cum_tick + event.tick
                # (time, midi_note, velocity)
                e = [cum_tick, event.data[0], event.data[1]]
                off_events.append(e)
                midi_keys.add(event.data[0])
            elif isinstance(event, midi.events.EndOfTrackEvent):
                pass
            # TODO: handle other midi events
            else:
                msg = "Track %d: %s event not handled" % (track_idx, type(event))
                warnings.warn(msg)

    # sort events according to time
    # (if they were generate from several tracks, this is required)
    on_events.sort(key=lambda x: float(x[0]))
    off_events.sort(key=lambda x: float(x[0]))

    return {'params': params, 'on_events': on_events, 'off_events': off_events, 'midi_keys': midi_keys}


def processType1(midifile):
    """
    Process midi file of format 1: a type 1 MIDI file should have two or more
    tracks. The first, by convention, contains song information such as the
    title, time signature, tempo, etc. (more detail in Track Chunk section).
    The second and following tracks contain a title, musical event data, etc.
    specific to that track.
    """
    params = Params()
    on_events = []
    off_events = []
    midi_keys = set([])
    for track_idx, track in enumerate(midifile):
        if track_idx == 0:
            for event in track:
                if isinstance(event, midi.events.TrackNameEvent):
                    params.name = "".join(map(chr, event.data))
                elif isinstance(event, midi.events.SetTempoEvent):
                    params.bpm = event.bpm
                elif isinstance(event, midi.events.TimeSignatureEvent):
                    params.time_signature['numerator'] = event.numerator
                    params.time_signature['denominator'] = event.denominator
                    params.time_signature['metro'] = event.metronome
                    params.time_signature['32nds'] = event.thirtyseconds
                # TODO: handle other midi events
                elif isinstance(event, midi.events.EndOfTrackEvent):
                    pass
                else:
                    msg = "Track %d: %s event not handled" % (track_idx, type(event))
                    warnings.warn(msg)
        else:
            cum_tick = 0
            for event in track:
                if isinstance(event, midi.events.NoteOnEvent):
                    # print repr(event.tick) + ":\t" + repr(event.data[0])
                    cum_tick = cum_tick + event.tick
                    # (time, midi_note, velocity)
                    e = [cum_tick, event.data[0], event.data[1]]
                    if not event.data[1] == 0:
                        on_events.append(e)
                        midi_keys.add(event.data[0])
                    else:
                        off_events.append(e)
                elif isinstance(event, midi.events.NoteOffEvent):
                    pass
                elif isinstance(event, midi.events.EndOfTrackEvent):
                    pass
                else:
                    msg = "Track %d: %s event not handled" % (track_idx, type(event))
                    warnings.warn(msg)

    # sort events according to time
    # (if they were generate from several tracks, this is required)
    on_events.sort(key=lambda x: float(x[0]))
    off_events.sort(key=lambda x: float(x[0]))

    return {'params': params, 'on_events': on_events, 'off_events': off_events, 'midi_keys': midi_keys}


def processType2(midifile):
    """
    Process midi file of format 2: A type 2 MIDI file is sort of a combination
    of the other two types. It contains multiple tracks, but each track
    represents a different sequence which may not necessarily be played
    simultaneously. This is meant to be used to save drum patterns, or other
    multi-pattern music sequences.
    """
    # TODO: implement
    warnings.warn("Processing of midi files of format 2 is not yet implemented")
    params = Params()
    on_events = []
    off_events = []
    midi_keys = set([])
    return {'params': params, 'on_events': on_events, 'off_events': off_events, 'midi_keys': midi_keys}


# this map defines which function processes the file, according to
# its midi format
FILE_FORMAT_MAP = {0: processType0,
                   1: processType1,
                   2: processType2}


def write_output_file(outputfile, file_data):
    """
    Given the processed midi data (from a midi_file), it writes it to an output
    TXT file.
    """
    params = file_data['params']
    on_events = file_data['on_events']
    off_events = file_data['off_events']
    # midi_keys = file_data['midi_keys']

    # write the output file
    of = open(outputfile, "wt")

    # # write file params
    # of.write("File parameters:\n")
    # of.write("\tname: %s\n" % (params.name,))
    # of.write("\tbpm: %f\n" % (params.bpm,))
    # of.write("\ttime signature: %d/%d\n\n" % (params.time_signature['numerator'],
    #                                           params.time_signature['denominator']))

    # write events
    of.write("NoteOn Events (time_stamp, midi_note, velocity):\n")
    for event in on_events:
        of.write(",".join(map(str, event)) + "\n")

    of.write("NoteOff Events (time_stamp, midi_note, velocity):\n")
    for event in off_events:
        of.write(",".join(map(str, event)) + "\n")

    of.close()


def process_file(midi_file):
    """
    Read a midi file, creates data structures suitable writing, and finally
    writes the TXT output.
    """
    inpath, infullname = os.path.split(midi_file)
    inname, inext = os.path.splitext(infullname)
    outputfile = os.path.join(OUTPUT_DIR, inname + ".txt")

    if not inext.lower() in (".mid", ".midi"):
        print "Skipping " + midi_file
        return

    print "Processing " + midi_file

    mf = midi.read_midifile(midi_file)
    ppq = mf.resolution  # ticks per quarter note

    # process the tracks according to the file format
    file_data = FILE_FORMAT_MAP[mf.format](mf)

    # get the tick period
    # FIXME: this assumes fixed tempo throughout the file.
    seconds_per_tick = 60.0 / file_data['params'].bpm / ppq

    if USE_TIME_IN_SECONDS:
        for event in file_data['on_events']:
            event[0] = seconds_per_tick * event[0]
        for event in file_data['off_events']:
            event[0] = seconds_per_tick * event[0]

    write_output_file(outputfile, file_data)


def process_dir(midi_dir):
    """
    Recursively traverses the input directory, attempting to process all the
    files in subdirectories.
    """
    for root, dirs, files in os.walk(midi_dir):
        for name in files:
            process_file(os.path.join(root, name))


if __name__ == '__main__':
    """
    Entry point.
    """
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    if len(sys.argv) > 1:
        midi_dir = sys.argv[1]
    else:
        midi_dir = "input_files/"

    process_dir(midi_dir)
